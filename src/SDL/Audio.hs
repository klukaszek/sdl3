{-# LANGUAGE CPP #-}
{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE ScopedTypeVariables #-}

{-|

"SDL.Audio" provides a high-level API to SDL3's audio device and audio stream capabilities.

In SDL3, all audio revolves around 'AudioStream's. Whether you want to play or record audio,
convert it, stream it, buffer it, or mix it, you're going to be passing it through an 'AudioStream'.

Audio streams are quite flexible; they can accept any amount of data at a time, in any supported format,
and output it as needed in any other format, even if the data format changes on either side halfway through.

An app opens an audio device and binds any number of audio streams to it, feeding more data to the streams
as available. When the device needs more data, it will pull it from all bound streams and mix them together
for playback.

-}

module SDL.Audio
  ( -- * Audio Device Management
    -- $audioDevice
    AudioDevice
    
    -- ** Opening and Closing 'AudioDevice's
  , openAudioDevice
  , closeAudioDevice
  , DefaultAudioDevice(..)
  , AudioDeviceSpec(..)
  
    -- ** Working with Opened Devices
    -- *** Pausing and Resuming 'AudioDevice's
  , pauseAudioDevice
  , resumeAudioDevice
  , isAudioDevicePaused
  
    -- *** Audio Device Gain
  , getAudioDeviceGain
  , setAudioDeviceGain
  
    -- *** Checking Device Type
  , isAudioDevicePhysical
  , isAudioDevicePlayback
  
    -- ** Getting Audio Device Information
  , getAudioDeviceFormat
  , getAudioDeviceChannelMap
  
    -- ** 'AudioFormat' and 'AudioSpec'
  , AudioFormat(..)
  , AudioSpec(..)
  
    -- ** Enumerating 'AudioDevice's
  , getAudioPlaybackDevices
  , getAudioRecordingDevices
  , getAudioDeviceName
  
    -- * Audio Stream Management
    -- $audioStream
  , AudioStream
  
    -- ** Creating and Destroying 'AudioStream's
  , createAudioStream
  , destroyAudioStream
  , openAudioDeviceStream
  
    -- ** Binding and Unbinding 'AudioStream's
  , bindAudioStream
  , unbindAudioStream
  , getAudioStreamDevice
  
    -- ** Managing 'AudioStream' Format
  , getAudioStreamFormat
  , setAudioStreamFormat
  
    -- ** Managing 'AudioStream' Properties
  , getAudioStreamProperties
  , getAudioStreamFrequencyRatio
  , setAudioStreamFrequencyRatio
  , getAudioStreamGain
  , setAudioStreamGain
  
    -- ** Channel Mapping
  , getAudioStreamInputChannelMap
  , getAudioStreamOutputChannelMap
  , setAudioStreamInputChannelMap
  , setAudioStreamOutputChannelMap
  
    -- ** Manipulating Audio Data
  , putAudioStreamData
  , getAudioStreamData
  , getAudioStreamAvailable
  , getAudioStreamQueued
  , flushAudioStream
  , clearAudioStream
  
    -- ** AudioStream Device Control
  , pauseAudioStreamDevice
  , resumeAudioStreamDevice
  , isAudioStreamDevicePaused
  
    -- ** Locking 'AudioStream's
  , withLockedAudioStream
  
    -- ** 'AudioStream' Callbacks
  , AudioStreamCallback
  , setAudioStreamGetCallback
  , setAudioStreamPutCallback
  
    -- * Audio Postmix Callback
  , AudioPostmixCallback
  , setAudioPostmixCallback
  
    -- * Channel Layout
    -- $channelLayout
  , Channels(..)
  
    -- * Audio Drivers
  , getAudioDrivers
  , currentAudioDriver
  , AudioDriver
  , audioDriverName
  
    -- * WAV Loading
  , loadWAV
  
    -- * Utility Functions
  , mixAudio
  , convertAudioSamples
  ) where

import Control.Exception (bracket)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Bits
import Data.Data (Data)
import Data.Int (Int8, Int16, Int32)
import Data.IORef (IORef, newIORef, writeIORef, readIORef)
import Data.Text (Text)
import Data.Traversable (for)
import Data.Typeable
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Foreign.Marshal.Utils
import Foreign.Ptr
import Foreign.Storable
import GHC.Exts (Constraint)
import GHC.Generics (Generic)
import SDL.Internal.Exception
import qualified Data.ByteString as BS
import qualified Data.Text.Encoding as Text
import qualified Data.Vector as V
import qualified Data.Vector.Storable.Mutable as MV
import qualified SDL.Raw.Audio as Raw
import qualified SDL.Raw.Enum as Raw
import qualified SDL.Raw.Types as Raw

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative
import Data.Foldable (Foldable)
import Data.Traversable (Traversable)
#endif

#if MIN_VERSION_base(4,12,0)
import Data.Kind (Type)
#else
# define Type *
#endif

{-

$audioDevice

In order to produce or record sound, you must first open an 'AudioDevice'. To do so,
pass an 'AudioDeviceSpec' to 'openAudioDevice'.

-}

{-

$audioStream

Audio streams are the core of SDL3's audio system. They allow you to:
- Convert between audio formats
- Resample audio data
- Mix multiple audio sources
- Buffer audio data
- Apply effects like gain control

-}

{-

$channelLayout

Audio data passing through SDL is uncompressed PCM data, interleaved. Each interleaved
channel of data is meant to be in a specific order.

Abbreviations:
  - FRONT = single mono speaker
  - FL = front left speaker
  - FR = front right speaker
  - FC = front center speaker
  - BL = back left speaker
  - BR = back right speaker
  - SR = surround right speaker
  - SL = surround left speaker
  - BC = back center speaker
  - LFE = low-frequency speaker

These are listed in the order they are laid out in memory:

  - 1 channel (mono) layout: FRONT
  - 2 channels (stereo) layout: FL, FR
  - 3 channels (2.1) layout: FL, FR, LFE
  - 4 channels (quad) layout: FL, FR, BL, BR
  - 5 channels (4.1) layout: FL, FR, LFE, BL, BR
  - 6 channels (5.1) layout: FL, FR, FC, LFE, BL, BR (last two can also be SL, SR)
  - 7 channels (6.1) layout: FL, FR, FC, LFE, BC, SL, SR
  - 8 channels (7.1) layout: FL, FR, FC, LFE, BL, BR, SL, SR

-}

-- | Specification for opening an audio device.
data AudioDeviceSpec = AudioDeviceSpec
  { deviceSpecFormat :: AudioSpec
    -- ^ The format specification for the audio device.
  , deviceSpecName :: Maybe Text
    -- ^ The name of the audio device to be opened. If 'Nothing',
    -- a default device will be used.
  } deriving (Typeable)

-- | Default audio devices that can be used when opening audio devices.
data DefaultAudioDevice
  = DefaultPlaybackDevice  -- ^ Default audio playback device
  | DefaultRecordingDevice -- ^ Default audio recording device
  deriving (Show, Eq, Typeable)

-- | Audio device instance. These can be created via 'openAudioDevice' and should be closed with 'closeAudioDevice'.
newtype AudioDevice = AudioDevice Raw.AudioDeviceID
  deriving (Eq, Typeable)

-- | Audio stream instance. Created with 'createAudioStream' and should be destroyed with 'destroyAudioStream'.
newtype AudioStream = AudioStream (Ptr Raw.AudioStream)
  deriving (Eq, Typeable)

-- | Callback type for audio stream data processing
type AudioStreamCallback = AudioStream -> Int -> Int -> IO ()

-- | Callback type for audio postmix processing
type AudioPostmixCallback = AudioSpec -> MV.IOVector Float -> IO ()

-- | Format specifier for audio data.
data AudioFormat sampleType where
  Signed8BitAudio :: AudioFormat Int8
  Unsigned8BitAudio :: AudioFormat Word8
  Signed16BitLEAudio :: AudioFormat Int16
  Signed16BitBEAudio :: AudioFormat Int16
  Signed16BitNativeAudio :: AudioFormat Int16
  Unsigned16BitLEAudio :: AudioFormat Word16
  Unsigned16BitBEAudio :: AudioFormat Word16
  Unsigned16BitNativeAudio :: AudioFormat Word16
  Signed32BitLEAudio :: AudioFormat Int32
  Signed32BitBEAudio :: AudioFormat Int32
  Signed32BitNativeAudio :: AudioFormat Int32
  FloatingLEAudio :: AudioFormat Float
  FloatingBEAudio :: AudioFormat Float
  FloatingNativeAudio :: AudioFormat Float

deriving instance Eq (AudioFormat sampleType)
deriving instance Ord (AudioFormat sampleType)
deriving instance Show (AudioFormat sampleType)

data AnAudioFormat where
  AnAudioFormat :: AudioFormat sampleType -> AnAudioFormat

encodeAudioFormat :: AudioFormat sampleType -> Word32
encodeAudioFormat Signed8BitAudio = Raw.SDL_AUDIO_S8
encodeAudioFormat Unsigned8BitAudio = Raw.SDL_AUDIO_U8
encodeAudioFormat Signed16BitLEAudio = Raw.SDL_AUDIO_S16LE
encodeAudioFormat Signed16BitBEAudio = Raw.SDL_AUDIO_S16BE
encodeAudioFormat Signed16BitNativeAudio = Raw.SDL_AUDIO_S16
encodeAudioFormat Signed32BitLEAudio = Raw.SDL_AUDIO_S32LE
encodeAudioFormat Signed32BitBEAudio = Raw.SDL_AUDIO_S32BE
encodeAudioFormat Signed32BitNativeAudio = Raw.SDL_AUDIO_S32
encodeAudioFormat FloatingLEAudio = Raw.SDL_AUDIO_F32LE
encodeAudioFormat FloatingBEAudio = Raw.SDL_AUDIO_F32BE
encodeAudioFormat FloatingNativeAudio = Raw.SDL_AUDIO_F32

decodeAudioFormat :: Word32 -> AnAudioFormat
decodeAudioFormat Raw.SDL_AUDIO_S8 = AnAudioFormat Signed8BitAudio
decodeAudioFormat Raw.SDL_AUDIO_U8 = AnAudioFormat Unsigned8BitAudio
decodeAudioFormat Raw.SDL_AUDIO_S16LE = AnAudioFormat Signed16BitLEAudio
decodeAudioFormat Raw.SDL_AUDIO_S16BE = AnAudioFormat Signed16BitBEAudio
decodeAudioFormat Raw.SDL_AUDIO_S16 = AnAudioFormat Signed16BitNativeAudio
decodeAudioFormat Raw.SDL_AUDIO_S32LE = AnAudioFormat Signed32BitLEAudio
decodeAudioFormat Raw.SDL_AUDIO_S32BE = AnAudioFormat Signed32BitBEAudio
decodeAudioFormat Raw.SDL_AUDIO_S32 = AnAudioFormat Signed32BitNativeAudio
decodeAudioFormat Raw.SDL_AUDIO_F32LE = AnAudioFormat FloatingLEAudio
decodeAudioFormat Raw.SDL_AUDIO_F32BE = AnAudioFormat FloatingBEAudio
decodeAudioFormat Raw.SDL_AUDIO_F32 = AnAudioFormat FloatingNativeAudio
decodeAudioFormat x = error ("decodeAudioFormat failed: Unknown format " ++ show x)

-- | Audio channel configurations
data Channels
  = Mono            -- ^ A single speaker
  | Stereo          -- ^ A traditional left/right stereo system
  | TwoPointOne     -- ^ 2.1 surround sound
  | Quad            -- ^ 4 speakers (front left, front right, back left, back right)
  | FourPointOne    -- ^ 4.1 surround sound
  | FivePointOne    -- ^ 5.1 surround sound
  | SixPointOne     -- ^ 6.1 surround sound
  | SevenPointOne   -- ^ 7.1 surround sound
  deriving (Bounded, Data, Enum, Eq, Generic, Ord, Read, Show, Typeable)

channelsToInt :: Channels -> CInt
channelsToInt Mono = 1
channelsToInt Stereo = 2
channelsToInt TwoPointOne = 3
channelsToInt Quad = 4
channelsToInt FourPointOne = 5
channelsToInt FivePointOne = 6
channelsToInt SixPointOne = 7
channelsToInt SevenPointOne = 8

intToChannels :: CInt -> Maybe Channels
intToChannels 1 = Just Mono
intToChannels 2 = Just Stereo
intToChannels 3 = Just TwoPointOne
intToChannels 4 = Just Quad
intToChannels 5 = Just FourPointOne
intToChannels 6 = Just FivePointOne
intToChannels 7 = Just SixPointOne
intToChannels 8 = Just SevenPointOne
intToChannels _ = Nothing

-- | AudioSpec is the specification of audio format.
data AudioSpec = forall sampleType. AudioSpec
  { audioSpecFormat :: !(AudioFormat sampleType)
    -- ^ Audio data format
  , audioSpecChannels :: !Channels
    -- ^ Number of separate sound channels
  , audioSpecFreq :: !CInt
    -- ^ DSP frequency (samples per second)
  }
  deriving (Typeable)

-- | Open an audio device with the specified parameters.
--
-- You can open both playback and recording devices through this function.
-- Playback devices will take data from bound audio streams, mix it, and send
-- it to the hardware. Recording devices will feed any bound audio streams
-- with a copy of any incoming data.
openAudioDevice :: (MonadIO m) 
                => Either DefaultAudioDevice AudioDevice -- ^ Device to open (either a default or a specific device ID)
                -> AudioDeviceSpec                       -- ^ Audio device specification
                -> m AudioDevice
openAudioDevice device spec = liftIO $ do
  let devId = case device of
                Left DefaultPlaybackDevice -> Raw.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK
                Left DefaultRecordingDevice -> Raw.SDL_AUDIO_DEVICE_DEFAULT_RECORDING
                Right (AudioDevice id) -> id
  
  withRawAudioSpec (deviceSpecFormat spec) $ \rawSpec -> do
    -- Get device name if specified
    case deviceSpecName spec of
      Nothing -> do
        resultId <- throwIf0 "SDL.Audio.openAudioDevice" "SDL_OpenAudioDevice" $
          Raw.openAudioDevice devId rawSpec
        return $ AudioDevice resultId
        
      Just name -> do
        Text.encodeUtf8 name `BS.useAsCString` \cName -> do
          resultId <- throwIf0 "SDL.Audio.openAudioDevice" "SDL_OpenAudioDevice" $
            Raw.openAudioDevice devId rawSpec
          return $ AudioDevice resultId

-- | Close a previously opened audio device.
closeAudioDevice :: (MonadIO m) => AudioDevice -> m ()
closeAudioDevice (AudioDevice devid) = liftIO $ 
  Raw.closeAudioDevice devid

-- | Pause audio playback on a specified device.
pauseAudioDevice :: (MonadIO m) => AudioDevice -> m Bool
pauseAudioDevice (AudioDevice devid) = liftIO $
  Raw.pauseAudioDevice devid

-- | Resume audio playback on a previously paused device.
resumeAudioDevice :: (MonadIO m) => AudioDevice -> m Bool
resumeAudioDevice (AudioDevice devid) = liftIO $
  Raw.resumeAudioDevice devid

-- | Check if an audio device is currently paused.
isAudioDevicePaused :: (MonadIO m) => AudioDevice -> m Bool
isAudioDevicePaused (AudioDevice devid) = liftIO $
  Raw.audioDevicePaused devid

-- | Get the gain (volume) of an audio device.
getAudioDeviceGain :: (MonadIO m) => AudioDevice -> m Float
getAudioDeviceGain (AudioDevice devid) = liftIO $ do
  gain <- Raw.getAudioDeviceGain devid
  if gain < 0
    then throwSDLError "SDL.Audio.getAudioDeviceGain" "SDL_GetAudioDeviceGain"
    else return gain

-- | Set the gain (volume) of an audio device.
-- 
-- The gain is a float value where 1.0 is normal volume, 0.0 is silence,
-- and values higher than 1.0 will amplify the sound.
setAudioDeviceGain :: (MonadIO m) => AudioDevice -> Float -> m Bool
setAudioDeviceGain (AudioDevice devid) gain = liftIO $
  Raw.setAudioDeviceGain devid gain

-- | Check if an audio device represents physical hardware (vs. logical device).
isAudioDevicePhysical :: (MonadIO m) => AudioDevice -> m Bool
isAudioDevicePhysical (AudioDevice devid) = liftIO $
  Raw.isAudioDevicePhysical devid

-- | Check if an audio device is for playback (vs. recording).
isAudioDevicePlayback :: (MonadIO m) => AudioDevice -> m Bool
isAudioDevicePlayback (AudioDevice devid) = liftIO $
  Raw.isAudioDevicePlayback devid

-- | Get the current audio format of a specific audio device.
getAudioDeviceFormat :: (MonadIO m) => AudioDevice -> m (AudioSpec, Int)
getAudioDeviceFormat (AudioDevice devid) = liftIO $
  alloca $ \specPtr ->
    alloca $ \sampleFramesPtr -> do
      success <- Raw.getAudioDeviceFormat devid specPtr sampleFramesPtr
      if success
        then do
          rawSpec <- peek specPtr
          sampleFrames <- peek sampleFramesPtr
          let format = decodeAudioFormat (Raw.audioSpecFormat rawSpec)
              channels = fromMaybe (error "Unknown channel configuration") 
                          (intToChannels (Raw.audioSpecChannels rawSpec))
              freq = Raw.audioSpecFreq rawSpec
              spec = case format of
                      AnAudioFormat fmt -> AudioSpec fmt channels freq
          return (spec, fromIntegral sampleFrames)
        else throwSDLError "SDL.Audio.getAudioDeviceFormat" "SDL_GetAudioDeviceFormat"

-- | Get the current channel map of an audio device.
getAudioDeviceChannelMap :: (MonadIO m) => AudioDevice -> m (Maybe [Int])
getAudioDeviceChannelMap (AudioDevice devid) = liftIO $ do
  (mapPtr, count) <- Raw.getAudioDeviceChannelMap devid
  if mapPtr == nullPtr
    then return Nothing
    else do
      channelMap <- peekArray (fromIntegral count) mapPtr
      let result = map fromIntegral channelMap
      free mapPtr
      return (Just result)

-- | Get a list of all audio playback devices connected to the system.
getAudioPlaybackDevices :: (MonadIO m) => m (V.Vector AudioDevice)
getAudioPlaybackDevices = liftIO $ do
  (devicesPtr, count) <- Raw.getAudioPlaybackDevices
  if devicesPtr == nullPtr
    then return V.empty
    else do
      devices <- peekArray (fromIntegral count) devicesPtr
      free devicesPtr
      return $ V.fromList (map AudioDevice devices)

-- | Get a list of all audio recording devices connected to the system.
getAudioRecordingDevices :: (MonadIO m) => m (V.Vector AudioDevice)
getAudioRecordingDevices = liftIO $ do
  (devicesPtr, count) <- Raw.getAudioRecordingDevices
  if devicesPtr == nullPtr
    then return V.empty
    else do
      devices <- peekArray (fromIntegral count) devicesPtr
      free devicesPtr
      return $ V.fromList (map AudioDevice devices)

-- | Get the human-readable name of an audio device.
getAudioDeviceName :: (MonadIO m) => AudioDevice -> m Text
getAudioDeviceName (AudioDevice devid) = liftIO $ do
  cstr <- throwIfNull "SDL.Audio.getAudioDeviceName" "SDL_GetAudioDeviceName" $
    Raw.getAudioDeviceName devid
  Text.decodeUtf8 <$> BS.packCString cstr

-- | Create a new audio stream.
createAudioStream :: (MonadIO m) => AudioSpec -> AudioSpec -> m AudioStream
createAudioStream srcSpec dstSpec = liftIO $
  withRawAudioSpec srcSpec $ \srcRawSpec ->
    withRawAudioSpec dstSpec $ \dstRawSpec -> do
      streamPtr <- throwIfNull "SDL.Audio.createAudioStream" "SDL_CreateAudioStream" $
        Raw.createAudioStream srcRawSpec dstRawSpec
      return (AudioStream streamPtr)

-- | Destroy an audio stream.
destroyAudioStream :: (MonadIO m) => AudioStream -> m ()
destroyAudioStream (AudioStream streamPtr) = liftIO $
  Raw.destroyAudioStream streamPtr

-- | Helper function to provide scope-based locking of an audio stream.
withLockedAudioStream :: (MonadIO m) => AudioStream -> (AudioStream -> IO a) -> m a
withLockedAudioStream stream@(AudioStream streamPtr) action = liftIO $
  bracket 
    (do
      success <- Raw.lockAudioStream streamPtr
      unless success $ throwSDLError "SDL.Audio.withLockedAudioStream" "SDL_LockAudioStream"
      return ())
    (\_ -> do
      success <- Raw.unlockAudioStream streamPtr
      unless success $ throwSDLError "SDL.Audio.withLockedAudioStream" "SDL_UnlockAudioStream")
    (\_ -> action stream)

-- | Bind an audio stream to an audio device.
bindAudioStream :: (MonadIO m) => AudioDevice -> AudioStream -> m Bool
bindAudioStream (AudioDevice devid) (AudioStream streamPtr) = liftIO $
  Raw.bindAudioStream devid streamPtr

-- | Unbind an audio stream from its audio device.
unbindAudioStream :: (MonadIO m) => AudioStream -> m ()
unbindAudioStream (AudioStream streamPtr) = liftIO $
  Raw.unbindAudioStream streamPtr

-- | Get the audio device a stream is bound to.
getAudioStreamDevice :: (MonadIO m) => AudioStream -> m (Maybe AudioDevice)
getAudioStreamDevice (AudioStream streamPtr) = liftIO $ do
  devid <- Raw.getAudioStreamDevice streamPtr
  if devid == 0
    then return Nothing
    else return (Just (AudioDevice devid))

-- | Get the current format of an audio stream.
getAudioStreamFormat :: (MonadIO m) => AudioStream -> m (AudioSpec, AudioSpec)
getAudioStreamFormat (AudioStream streamPtr) = liftIO $
  alloca $ \srcSpecPtr ->
    alloca $ \dstSpecPtr -> do
      success <- Raw.getAudioStreamFormat streamPtr srcSpecPtr dstSpecPtr
      if success
        then do
          srcRawSpec <- peek srcSpecPtr
          dstRawSpec <- peek dstSpecPtr
          
          let srcFormat = decodeAudioFormat (Raw.audioSpecFormat srcRawSpec)
              srcChannels = fromMaybe (error "Unknown channel configuration") 
                              (intToChannels (Raw.audioSpecChannels srcRawSpec))
              srcFreq = Raw.audioSpecFreq srcRawSpec
              
              dstFormat = decodeAudioFormat (Raw.audioSpecFormat dstRawSpec)
              dstChannels = fromMaybe (error "Unknown channel configuration") 
                              (intToChannels (Raw.audioSpecChannels dstRawSpec))
              dstFreq = Raw.audioSpecFreq dstRawSpec
              
              srcSpec = case srcFormat of
                          AnAudioFormat fmt -> AudioSpec fmt srcChannels srcFreq
              dstSpec = case dstFormat of
                          AnAudioFormat fmt -> AudioSpec fmt dstChannels dstFreq
                          
          return (srcSpec, dstSpec)
        else throwSDLError "SDL.Audio.getAudioStreamFormat" "SDL_GetAudioStreamFormat"

-- | Change the input and output formats of an audio stream.
setAudioStreamFormat :: (MonadIO m) => AudioStream -> Maybe AudioSpec -> Maybe AudioSpec -> m Bool
setAudioStreamFormat (AudioStream streamPtr) maybeSourceSpec maybeDestSpec = liftIO $
  maybeWithPtr withRawAudioSpec maybeSourceSpec $ \srcSpecPtr ->
    maybeWithPtr withRawAudioSpec maybeDestSpec $ \dstSpecPtr ->
      Raw.setAudioStreamFormat streamPtr srcSpecPtr dstSpecPtr

-- | Get the properties associated with an audio stream.
getAudioStreamProperties :: (MonadIO m) => AudioStream -> m Raw.PropertiesID
getAudioStreamProperties (AudioStream streamPtr) = liftIO $
  throwIf0 "SDL.Audio.getAudioStreamProperties" "SDL_GetAudioStreamProperties" $
    Raw.getAudioStreamProperties streamPtr

-- | Get the frequency ratio of an audio stream.
getAudioStreamFrequencyRatio :: (MonadIO m) => AudioStream -> m Float
getAudioStreamFrequencyRatio (AudioStream streamPtr) = liftIO $ do
  ratio <- Raw.getAudioStreamFrequencyRatio streamPtr
  if ratio <= 0.0
    then throwSDLError "SDL.Audio.getAudioStreamFrequencyRatio" "SDL_GetAudioStreamFrequencyRatio"
    else return ratio

-- | Change the frequency ratio of an audio stream.
setAudioStreamFrequencyRatio :: (MonadIO m) => AudioStream -> Float -> m Bool
setAudioStreamFrequencyRatio (AudioStream streamPtr) ratio = liftIO $
  Raw.setAudioStreamFrequencyRatio streamPtr ratio

-- | Get the gain of an audio stream.
getAudioStreamGain :: (MonadIO m) => AudioStream -> m Float
getAudioStreamGain (AudioStream streamPtr) = liftIO $ do
  gain <- Raw.getAudioStreamGain streamPtr
  if gain < 0
    then throwSDLError "SDL.Audio.getAudioStreamGain" "SDL_GetAudioStreamGain"
    else return gain

-- | Set the gain of an audio stream.
setAudioStreamGain :: (MonadIO m) => AudioStream -> Float -> m Bool
setAudioStreamGain (AudioStream streamPtr) gain = liftIO $
  Raw.setAudioStreamGain streamPtr gain

-- | Get the current input channel map of an audio stream.
getAudioStreamInputChannelMap :: (MonadIO m) => AudioStream -> m (Maybe [Int])
getAudioStreamInputChannelMap (AudioStream streamPtr) = liftIO $ do
  (mapPtr, count) <- Raw.getAudioStreamInputChannelMap streamPtr
  if mapPtr == nullPtr
    then return Nothing
    else do
      channelMap <- peekArray (fromIntegral count) mapPtr
      let result = map fromIntegral channelMap
      free mapPtr
      return (Just result)

-- | Get the current output channel map of an audio stream.
getAudioStreamOutputChannelMap :: (MonadIO m) => AudioStream -> m (Maybe [Int])
getAudioStreamOutputChannelMap (AudioStream streamPtr) = liftIO $ do
  (mapPtr, count) <- Raw.getAudioStreamOutputChannelMap streamPtr
  if mapPtr == nullPtr
    then return Nothing
    else do
      channelMap <- peekArray (fromIntegral count) mapPtr
      let result = map fromIntegral channelMap
      free mapPtr
      return (Just result)

-- | Set the current input channel map of an audio stream.
setAudioStreamInputChannelMap :: (MonadIO m) => AudioStream -> Maybe [Int] -> m Bool
setAudioStreamInputChannelMap (AudioStream streamPtr) Nothing = liftIO $
  Raw.setAudioStreamInputChannelMap streamPtr nullPtr 0

setAudioStreamInputChannelMap (AudioStream streamPtr) (Just channelMap) = liftIO $
  withArray (map fromIntegral channelMap) $ \mapPtr ->
    Raw.setAudioStreamInputChannelMap streamPtr mapPtr (fromIntegral $ length channelMap)

-- | Set the current output channel map of an audio stream.
setAudioStreamOutputChannelMap :: (MonadIO m) => AudioStream -> Maybe [Int] -> m Bool
setAudioStreamOutputChannelMap (AudioStream streamPtr) Nothing = liftIO $
  Raw.setAudioStreamOutputChannelMap streamPtr nullPtr 0

setAudioStreamOutputChannelMap (AudioStream streamPtr) (Just channelMap) = liftIO $
  withArray (map fromIntegral channelMap) $ \mapPtr ->
    Raw.setAudioStreamOutputChannelMap streamPtr mapPtr (fromIntegral $ length channelMap)

-- | Add data to the stream.
putAudioStreamData :: (MonadIO m) => AudioStream -> Ptr () -> Int -> m Bool
putAudioStreamData (AudioStream streamPtr) buf len = liftIO $
  Raw.putAudioStreamData streamPtr buf (fromIntegral len)

-- | Get converted/resampled data from the stream.
getAudioStreamData :: (MonadIO m) => AudioStream -> Ptr () -> Int -> m Int
getAudioStreamData (AudioStream streamPtr) buf len = liftIO $ do
  result <- Raw.getAudioStreamData streamPtr buf (fromIntegral len)
  if result < 0
    then throwSDLError "SDL.Audio.getAudioStreamData" "SDL_GetAudioStreamData"
    else return (fromIntegral result)

-- | Get the number of converted/resampled bytes available.
getAudioStreamAvailable :: (MonadIO m) => AudioStream -> m Int
getAudioStreamAvailable (AudioStream streamPtr) = liftIO $ do
  result <- Raw.getAudioStreamAvailable streamPtr
  if result < 0
    then throwSDLError "SDL.Audio.getAudioStreamAvailable" "SDL_GetAudioStreamAvailable"
    else return (fromIntegral result)

-- | Get the number of bytes currently queued in the stream.
getAudioStreamQueued :: (MonadIO m) => AudioStream -> m Int
getAudioStreamQueued (AudioStream streamPtr) = liftIO $ do
  result <- Raw.getAudioStreamQueued streamPtr
  if result < 0
    then throwSDLError "SDL.Audio.getAudioStreamQueued" "SDL_GetAudioStreamQueued"
    else return (fromIntegral result)

-- | Flush an audio stream, making all pending data available immediately.
flushAudioStream :: (MonadIO m) => AudioStream -> m Bool
flushAudioStream (AudioStream streamPtr) = liftIO $
  Raw.flushAudioStream streamPtr

-- | Clear any pending data in the stream.
clearAudioStream :: (MonadIO m) => AudioStream -> m Bool
clearAudioStream (AudioStream streamPtr) = liftIO $
  Raw.clearAudioStream streamPtr

-- | Pause the audio device associated with a stream.
pauseAudioStreamDevice :: (MonadIO m) => AudioStream -> m Bool
pauseAudioStreamDevice (AudioStream streamPtr) = liftIO $
  Raw.pauseAudioStreamDevice streamPtr

-- | Resume the audio device associated with a stream.
resumeAudioStreamDevice :: (MonadIO m) => AudioStream -> m Bool
resumeAudioStreamDevice (AudioStream streamPtr) = liftIO $
  Raw.resumeAudioStreamDevice streamPtr

-- | Check if the audio device associated with a stream is paused.
isAudioStreamDevicePaused :: (MonadIO m) => AudioStream -> m Bool
isAudioStreamDevicePaused (AudioStream streamPtr) = liftIO $
  Raw.audioStreamDevicePaused streamPtr

-- | Set a callback that runs when data is requested from an audio stream.
setAudioStreamGetCallback :: (MonadIO m) 
                          => AudioStream 
                          -> Maybe (AudioStreamCallback) 
                          -> m Bool
setAudioStreamGetCallback (AudioStream streamPtr) Nothing = liftIO $
  Raw.setAudioStreamGetCallback streamPtr Nothing nullPtr

setAudioStreamGetCallback (AudioStream streamPtr) (Just callback) = liftIO $ do
  -- Create callback wrapper that converts to our high-level type
  let wrappedCallback _ ptr additional total = 
        callback (AudioStream ptr) (fromIntegral additional) (fromIntegral total)
  Raw.setAudioStreamGetCallback streamPtr (Just wrappedCallback) nullPtr

-- | Set a callback that runs when data is added to an audio stream.
setAudioStreamPutCallback :: (MonadIO m) 
                          => AudioStream 
                          -> Maybe (AudioStreamCallback) 
                          -> m Bool
setAudioStreamPutCallback (AudioStream streamPtr) Nothing = liftIO $
  Raw.setAudioStreamPutCallback streamPtr Nothing nullPtr

setAudioStreamPutCallback (AudioStream streamPtr) (Just callback) = liftIO $ do
  -- Create callback wrapper that converts to our high-level type
  let wrappedCallback _ ptr additional total = 
        callback (AudioStream ptr) (fromIntegral additional) (fromIntegral total)
  Raw.setAudioStreamPutCallback streamPtr (Just wrappedCallback) nullPtr

-- | Set a callback that fires when data is about to be fed to an audio device.
setAudioPostmixCallback :: (MonadIO m) 
                        => AudioDevice 
                        -> Maybe (AudioPostmixCallback) 
                        -> m Bool
setAudioPostmixCallback (AudioDevice devid) Nothing = liftIO $
  Raw.setAudioPostmixCallback devid Nothing nullPtr

setAudioPostmixCallback (AudioDevice devid) (Just callback) = liftIO $ do
  -- Create callback wrapper that converts to our high-level types
  let wrappedCallback _ specPtr buffer buflen = do
        rawSpec <- peek specPtr
        let format = decodeAudioFormat (Raw.audioSpecFormat rawSpec)
            channels = fromMaybe (error "Unknown channel configuration") 
                          (intToChannels (Raw.audioSpecChannels rawSpec))
            freq = Raw.audioSpecFreq rawSpec
            spec = case format of
                    AnAudioFormat _ -> AudioSpec (FloatingNativeAudio) channels freq
        
        -- Create a MVector from the buffer
        let numFloats = fromIntegral buflen `div` sizeOf (undefined :: CFloat)
        fp <- newForeignPtr_ (castPtr buffer)
        let vec = MV.unsafeFromForeignPtr0 fp numFloats
        
        callback spec vec
        
  Raw.setAudioPostmixCallback devid (Just wrappedCallback) nullPtr

-- | Open an audio device stream.
--
-- This is a convenience function that handles opening both a device and a stream
-- in a single call. This is the most straightforward way to set up audio in SDL3.
openAudioDeviceStream :: (MonadIO m)
                      => Either DefaultAudioDevice AudioDevice  -- ^ Device to open
                      -> AudioSpec                              -- ^ Audio specification
                      -> Maybe (AudioStreamCallback)            -- ^ Optional callback
                      -> m AudioStream
openAudioDeviceStream device spec Nothing = liftIO $ do
  let devId = case device of
                Left DefaultPlaybackDevice -> Raw.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK
                Left DefaultRecordingDevice -> Raw.SDL_AUDIO_DEVICE_DEFAULT_RECORDING
                Right (AudioDevice id) -> id
                
  withRawAudioSpec spec $ \rawSpec -> do
    streamPtr <- throwIfNull "SDL.Audio.openAudioDeviceStream" "SDL_OpenAudioDeviceStream" $
      Raw.openAudioDeviceStream devId rawSpec Nothing nullPtr
    return (AudioStream streamPtr)

openAudioDeviceStream device spec (Just callback) = liftIO $ do
  let devId = case device of
                Left DefaultPlaybackDevice -> Raw.SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK
                Left DefaultRecordingDevice -> Raw.SDL_AUDIO_DEVICE_DEFAULT_RECORDING
                Right (AudioDevice id) -> id
                
  -- Create callback wrapper that converts to our high-level type
  let wrappedCallback _ ptr additional total = 
        callback (AudioStream ptr) (fromIntegral additional) (fromIntegral total)
                
  withRawAudioSpec spec $ \rawSpec -> do
    streamPtr <- throwIfNull "SDL.Audio.openAudioDeviceStream" "SDL_OpenAudioDeviceStream" $
      Raw.openAudioDeviceStream devId rawSpec (Just wrappedCallback) nullPtr
    return (AudioStream streamPtr)

-- | Load WAV audio from a file.
loadWAV :: (MonadIO m) => FilePath -> m (AudioSpec, BS.ByteString)
loadWAV path = liftIO $
  withCString path $ \cpath ->
    alloca $ \specPtr ->
      alloca $ \audioBuffPtr ->
        alloca $ \audioLenPtr -> do
          success <- Raw.loadWAV cpath specPtr audioBuffPtr audioLenPtr
          if success
            then do
              rawSpec <- peek specPtr
              audioBuffP <- peek audioBuffPtr
              audioLen <- peek audioLenPtr
              
              -- Get the audio data
              bs <- BS.packCStringLen (castPtr audioBuffP, fromIntegral audioLen)
              
              -- Free the buffer now that we've copied it
              free audioBuffP
              
              -- Convert the spec
              let format = decodeAudioFormat (Raw.audioSpecFormat rawSpec)
                  channels = fromMaybe (error "Unknown channel configuration") 
                              (intToChannels (Raw.audioSpecChannels rawSpec))
                  freq = Raw.audioSpecFreq rawSpec
                  spec = case format of
                          AnAudioFormat fmt -> AudioSpec fmt channels freq
                          
              return (spec, bs)
            else throwSDLError "SDL.Audio.loadWAV" "SDL_LoadWAV"

-- | Mix audio data with volume adjustment.
mixAudio :: (MonadIO m) => Ptr Word8 -> Ptr Word8 -> Raw.AudioFormat -> Word32 -> Float -> m Bool
mixAudio dst src format len volume = liftIO $
  Raw.mixAudio dst src format len volume

-- | Convert audio data from one format to another.
convertAudioSamples :: (MonadIO m) 
                    => AudioSpec 
                    -> Ptr Word8 
                    -> Int 
                    -> AudioSpec 
                    -> m (BS.ByteString, Int)
convertAudioSamples srcSpec srcData srcLen dstSpec = liftIO $
  withRawAudioSpec srcSpec $ \srcRawSpec ->
    withRawAudioSpec dstSpec $ \dstRawSpec ->
      alloca $ \dstDataPtr ->
        alloca $ \dstLenPtr -> do
          success <- Raw.convertAudioSamples 
                      srcRawSpec 
                      srcData 
                      (fromIntegral srcLen) 
                      dstRawSpec 
                      dstDataPtr 
                      dstLenPtr
          if success
            then do
              dstData <- peek dstDataPtr
              dstLen <- peek dstLenPtr
              
              -- Copy the audio data
              bs <- BS.packCStringLen (castPtr dstData, fromIntegral dstLen)
              
              -- Free the buffer now that we've copied it
              free dstData
              
              return (bs, fromIntegral dstLen)
            else throwSDLError "SDL.Audio.convertAudioSamples" "SDL_ConvertAudioSamples"

-- | An abstract description of an audio driver on the host machine.
newtype AudioDriver = AudioDriver Text
  deriving (Eq, Show, Typeable)

-- | Get the human readable name of an 'AudioDriver'
audioDriverName :: AudioDriver -> Text
audioDriverName (AudioDriver t) = t

-- | Obtain a list of all possible audio drivers for this system.
getAudioDrivers :: (MonadIO m) => m (V.Vector AudioDriver)
getAudioDrivers = liftIO $ do
  n <- Raw.getNumAudioDrivers
  fmap V.fromList $
    for [0 .. (n - 1)] $ \i -> do
      cstr <- Raw.getAudioDriver i
      AudioDriver . Text.decodeUtf8 <$> BS.packCString cstr

-- | Query SDL for the name of the currently initialized audio driver.
-- Returns Nothing if no driver has been initialized.
currentAudioDriver :: (MonadIO m) => m (Maybe Text)
currentAudioDriver = liftIO $ do
  cstr <- Raw.getCurrentAudioDriver
  if cstr == nullPtr
    then return Nothing
    else Just . Text.decodeUtf8 <$> BS.packCString cstr

-- Helper functions

-- | Create a Raw.AudioSpec from our high-level AudioSpec
withRawAudioSpec :: AudioSpec -> (Ptr Raw.AudioSpec -> IO a) -> IO a
withRawAudioSpec (AudioSpec format channels freq) action =
  alloca $ \specPtr -> do
    poke specPtr $ Raw.AudioSpec {
      Raw.audioSpecFormat = encodeAudioFormat format,
      Raw.audioSpecChannels = channelsToInt channels,
      Raw.audioSpecFreq = freq
    }
    action specPtr

-- | For functions that need a Maybe
maybeWithPtr :: (a -> (Ptr b -> IO c) -> IO c) -> Maybe a -> (Ptr b -> IO c) -> IO c
maybeWithPtr _ Nothing f = f nullPtr
maybeWithPtr with (Just x) f = with x f

-- | Convert between Bool and Num
fromBool :: Num a => Bool -> a
fromBool True = 1
fromBool False = 0

fromMaybe :: a -> Maybe a -> a
fromMaybe fallback Nothing = fallback
fromMaybe _ (Just x) = x

unless :: Monad m => Bool -> m () -> m ()
unless p s = if p then return () else s
