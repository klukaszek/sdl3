module SDL.Raw.Audio (
  -- * Audio Device Management
  getNumAudioDrivers,
  getAudioDriver,
  getCurrentAudioDriver,
  getAudioPlaybackDevices,
  getAudioRecordingDevices,
  getAudioDeviceName,
  getAudioDeviceFormat,
  getAudioDeviceChannelMap,
  openAudioDevice,
  isAudioDevicePhysical,
  isAudioDevicePlayback,
  pauseAudioDevice,
  resumeAudioDevice,
  audioDevicePaused,
  getAudioDeviceGain,
  setAudioDeviceGain,
  closeAudioDevice,
  
  -- * Audio Stream Management
  bindAudioStreams,
  bindAudioStream,
  unbindAudioStreams,
  unbindAudioStream,
  getAudioStreamDevice,
  createAudioStream,
  getAudioStreamProperties,
  getAudioStreamFormat,
  setAudioStreamFormat,
  getAudioStreamFrequencyRatio,
  setAudioStreamFrequencyRatio,
  getAudioStreamGain,
  setAudioStreamGain,
  getAudioStreamInputChannelMap,
  getAudioStreamOutputChannelMap,
  setAudioStreamInputChannelMap,
  setAudioStreamOutputChannelMap,
  putAudioStreamData,
  getAudioStreamData,
  getAudioStreamAvailable,
  getAudioStreamQueued,
  flushAudioStream,
  clearAudioStream,
  pauseAudioStreamDevice,
  resumeAudioStreamDevice,
  audioStreamDevicePaused,
  lockAudioStream,
  unlockAudioStream,
  setAudioStreamGetCallback,
  setAudioStreamPutCallback,
  destroyAudioStream,
  openAudioDeviceStream,
  
  -- * Audio Device Postmix
  setAudioPostmixCallback,
  
  -- * WAV Loading and Utility Functions
  loadWAV_IO,
  loadWAV,
  mixAudio,
  convertAudioSamples,
  getAudioFormatName,
  getSilenceValueForFormat
) where

import Control.Monad.IO.Class
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import Foreign.Marshal.Alloc (malloc, free)
import Foreign.Storable (peek)
import SDL.Raw.Enum
import SDL.Raw.Types
import SDL.Raw.Filesystem

-- Audio driver functions
foreign import ccall "SDL.h SDL_GetNumAudioDrivers" getNumAudioDriversFFI :: IO CInt
foreign import ccall "SDL.h SDL_GetAudioDriver" getAudioDriverFFI :: CInt -> IO CString
foreign import ccall "SDL.h SDL_GetCurrentAudioDriver" getCurrentAudioDriverFFI :: IO CString

-- Audio device functions
foreign import ccall "SDL.h SDL_GetAudioPlaybackDevices" getAudioPlaybackDevicesFFI :: Ptr CInt -> IO (Ptr AudioDeviceID)
foreign import ccall "SDL.h SDL_GetAudioRecordingDevices" getAudioRecordingDevicesFFI :: Ptr CInt -> IO (Ptr AudioDeviceID)
foreign import ccall "SDL.h SDL_GetAudioDeviceName" getAudioDeviceNameFFI :: AudioDeviceID -> IO CString
foreign import ccall "SDL.h SDL_GetAudioDeviceFormat" getAudioDeviceFormatFFI :: AudioDeviceID -> Ptr AudioSpec -> Ptr CInt -> IO CBool
foreign import ccall "SDL.h SDL_GetAudioDeviceChannelMap" getAudioDeviceChannelMapFFI :: AudioDeviceID -> Ptr CInt -> IO (Ptr CInt)
foreign import ccall "SDL.h SDL_OpenAudioDevice" openAudioDeviceFFI :: AudioDeviceID -> Ptr AudioSpec -> IO AudioDeviceID
foreign import ccall "SDL.h SDL_IsAudioDevicePhysical" isAudioDevicePhysicalFFI :: AudioDeviceID -> IO CBool
foreign import ccall "SDL.h SDL_IsAudioDevicePlayback" isAudioDevicePlaybackFFI :: AudioDeviceID -> IO CBool
foreign import ccall "SDL.h SDL_PauseAudioDevice" pauseAudioDeviceFFI :: AudioDeviceID -> IO CBool
foreign import ccall "SDL.h SDL_ResumeAudioDevice" resumeAudioDeviceFFI :: AudioDeviceID -> IO CBool
foreign import ccall "SDL.h SDL_AudioDevicePaused" audioDevicePausedFFI :: AudioDeviceID -> IO CBool
foreign import ccall "SDL.h SDL_GetAudioDeviceGain" getAudioDeviceGainFFI :: AudioDeviceID -> IO CFloat
foreign import ccall "SDL.h SDL_SetAudioDeviceGain" setAudioDeviceGainFFI :: AudioDeviceID -> CFloat -> IO CBool
foreign import ccall "SDL.h SDL_CloseAudioDevice" closeAudioDeviceFFI :: AudioDeviceID -> IO ()

-- Audio stream binding
foreign import ccall "SDL.h SDL_BindAudioStreams" bindAudioStreamsFFI :: AudioDeviceID -> Ptr (Ptr AudioStream) -> CInt -> IO CBool
foreign import ccall "SDL.h SDL_BindAudioStream" bindAudioStreamFFI :: AudioDeviceID -> Ptr AudioStream -> IO CBool
foreign import ccall "SDL.h SDL_UnbindAudioStreams" unbindAudioStreamsFFI :: Ptr (Ptr AudioStream) -> CInt -> IO ()
foreign import ccall "SDL.h SDL_UnbindAudioStream" unbindAudioStreamFFI :: Ptr AudioStream -> IO ()
foreign import ccall "SDL.h SDL_GetAudioStreamDevice" getAudioStreamDeviceFFI :: Ptr AudioStream -> IO AudioDeviceID

-- Audio stream management
foreign import ccall "SDL.h SDL_CreateAudioStream" createAudioStreamFFI :: Ptr AudioSpec -> Ptr AudioSpec -> IO (Ptr AudioStream)
foreign import ccall "SDL.h SDL_GetAudioStreamProperties" getAudioStreamPropertiesFFI :: Ptr AudioStream -> IO PropertiesID
foreign import ccall "SDL.h SDL_GetAudioStreamFormat" getAudioStreamFormatFFI :: Ptr AudioStream -> Ptr AudioSpec -> Ptr AudioSpec -> IO CBool
foreign import ccall "SDL.h SDL_SetAudioStreamFormat" setAudioStreamFormatFFI :: Ptr AudioStream -> Ptr AudioSpec -> Ptr AudioSpec -> IO CBool
foreign import ccall "SDL.h SDL_GetAudioStreamFrequencyRatio" getAudioStreamFrequencyRatioFFI :: Ptr AudioStream -> IO CFloat
foreign import ccall "SDL.h SDL_SetAudioStreamFrequencyRatio" setAudioStreamFrequencyRatioFFI :: Ptr AudioStream -> CFloat -> IO CBool
foreign import ccall "SDL.h SDL_GetAudioStreamGain" getAudioStreamGainFFI :: Ptr AudioStream -> IO CFloat
foreign import ccall "SDL.h SDL_SetAudioStreamGain" setAudioStreamGainFFI :: Ptr AudioStream -> CFloat -> IO CBool
foreign import ccall "SDL.h SDL_GetAudioStreamInputChannelMap" getAudioStreamInputChannelMapFFI :: Ptr AudioStream -> Ptr CInt -> IO (Ptr CInt)
foreign import ccall "SDL.h SDL_GetAudioStreamOutputChannelMap" getAudioStreamOutputChannelMapFFI :: Ptr AudioStream -> Ptr CInt -> IO (Ptr CInt)
foreign import ccall "SDL.h SDL_SetAudioStreamInputChannelMap" setAudioStreamInputChannelMapFFI :: Ptr AudioStream -> Ptr CInt -> CInt -> IO CBool
foreign import ccall "SDL.h SDL_SetAudioStreamOutputChannelMap" setAudioStreamOutputChannelMapFFI :: Ptr AudioStream -> Ptr CInt -> CInt -> IO CBool
foreign import ccall "SDL.h SDL_PutAudioStreamData" putAudioStreamDataFFI :: Ptr AudioStream -> Ptr () -> CInt -> IO CBool
foreign import ccall "SDL.h SDL_GetAudioStreamData" getAudioStreamDataFFI :: Ptr AudioStream -> Ptr () -> CInt -> IO CInt
foreign import ccall "SDL.h SDL_GetAudioStreamAvailable" getAudioStreamAvailableFFI :: Ptr AudioStream -> IO CInt
foreign import ccall "SDL.h SDL_GetAudioStreamQueued" getAudioStreamQueuedFFI :: Ptr AudioStream -> IO CInt
foreign import ccall "SDL.h SDL_FlushAudioStream" flushAudioStreamFFI :: Ptr AudioStream -> IO CBool
foreign import ccall "SDL.h SDL_ClearAudioStream" clearAudioStreamFFI :: Ptr AudioStream -> IO CBool
foreign import ccall "SDL.h SDL_PauseAudioStreamDevice" pauseAudioStreamDeviceFFI :: Ptr AudioStream -> IO CBool
foreign import ccall "SDL.h SDL_ResumeAudioStreamDevice" resumeAudioStreamDeviceFFI :: Ptr AudioStream -> IO CBool
foreign import ccall "SDL.h SDL_AudioStreamDevicePaused" audioStreamDevicePausedFFI :: Ptr AudioStream -> IO CBool
foreign import ccall "SDL.h SDL_LockAudioStream" lockAudioStreamFFI :: Ptr AudioStream -> IO CBool
foreign import ccall "SDL.h SDL_UnlockAudioStream" unlockAudioStreamFFI :: Ptr AudioStream -> IO CBool

-- Audio stream callbacks are complex and will need special handling
foreign import ccall "wrapper" mkAudioStreamCallback :: (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()) -> IO (FunPtr (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()))
foreign import ccall "SDL.h SDL_SetAudioStreamGetCallback" setAudioStreamGetCallbackFFI :: Ptr AudioStream -> FunPtr (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()) -> Ptr () -> IO CBool
foreign import ccall "SDL.h SDL_SetAudioStreamPutCallback" setAudioStreamPutCallbackFFI :: Ptr AudioStream -> FunPtr (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()) -> Ptr () -> IO CBool

foreign import ccall "SDL.h SDL_DestroyAudioStream" destroyAudioStreamFFI :: Ptr AudioStream -> IO ()
foreign import ccall "SDL.h SDL_OpenAudioDeviceStream" openAudioDeviceStreamFFI :: AudioDeviceID -> Ptr AudioSpec -> FunPtr (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()) -> Ptr () -> IO (Ptr AudioStream)

-- Audio postmix callback
foreign import ccall "wrapper" mkAudioPostmixCallback :: (Ptr () -> Ptr AudioSpec -> Ptr CFloat -> CInt -> IO ()) -> IO (FunPtr (Ptr () -> Ptr AudioSpec -> Ptr CFloat -> CInt -> IO ()))
foreign import ccall "SDL.h SDL_SetAudioPostmixCallback" setAudioPostmixCallbackFFI :: AudioDeviceID -> FunPtr (Ptr () -> Ptr AudioSpec -> Ptr CFloat -> CInt -> IO ()) -> Ptr () -> IO CBool

-- WAV and utility functions
foreign import ccall "SDL.h SDL_LoadWAV_IO" loadWAV_IOFFI :: Ptr IOStream -> CBool -> Ptr AudioSpec -> Ptr (Ptr Word8) -> Ptr Word32 -> IO CBool
foreign import ccall "SDL.h SDL_LoadWAV" loadWAVFFI :: CString -> Ptr AudioSpec -> Ptr (Ptr Word8) -> Ptr Word32 -> IO CBool
foreign import ccall "SDL.h SDL_MixAudio" mixAudioFFI :: Ptr Word8 -> Ptr Word8 -> AudioFormat -> Word32 -> CFloat -> IO CBool
foreign import ccall "SDL.h SDL_ConvertAudioSamples" convertAudioSamplesFFI :: Ptr AudioSpec -> Ptr Word8 -> CInt -> Ptr AudioSpec -> Ptr (Ptr Word8) -> Ptr CInt -> IO CBool
foreign import ccall "SDL.h SDL_GetAudioFormatName" getAudioFormatNameFFI :: AudioFormat -> IO CString
foreign import ccall "SDL.h SDL_GetSilenceValueForFormat" getSilenceValueForFormatFFI :: AudioFormat -> IO CInt

-- Now provide Haskell wrappers for each function

-- Audio driver functions
getNumAudioDrivers :: MonadIO m => m CInt
getNumAudioDrivers = liftIO getNumAudioDriversFFI
{-# INLINE getNumAudioDrivers #-}

getAudioDriver :: MonadIO m => CInt -> m CString
getAudioDriver index = liftIO $ getAudioDriverFFI index
{-# INLINE getAudioDriver #-}

getCurrentAudioDriver :: MonadIO m => m CString
getCurrentAudioDriver = liftIO getCurrentAudioDriverFFI
{-# INLINE getCurrentAudioDriver #-}

-- Audio device functions
getAudioPlaybackDevices :: MonadIO m => m (Ptr AudioDeviceID, CInt)
getAudioPlaybackDevices = liftIO $ do
  countPtr <- malloc
  devicesPtr <- getAudioPlaybackDevicesFFI countPtr
  count <- peek countPtr
  free countPtr
  return (devicesPtr, count)
{-# INLINE getAudioPlaybackDevices #-}

getAudioRecordingDevices :: MonadIO m => m (Ptr AudioDeviceID, CInt)
getAudioRecordingDevices = liftIO $ do
  countPtr <- malloc
  devicesPtr <- getAudioRecordingDevicesFFI countPtr
  count <- peek countPtr
  free countPtr
  return (devicesPtr, count)
{-# INLINE getAudioRecordingDevices #-}

getAudioDeviceName :: MonadIO m => AudioDeviceID -> m CString
getAudioDeviceName devid = liftIO $ getAudioDeviceNameFFI devid
{-# INLINE getAudioDeviceName #-}

getAudioDeviceFormat :: MonadIO m => AudioDeviceID -> Ptr AudioSpec -> Ptr CInt -> m Bool
getAudioDeviceFormat devid spec sample_frames = liftIO $ toBool <$> getAudioDeviceFormatFFI devid spec sample_frames
{-# INLINE getAudioDeviceFormat #-}

getAudioDeviceChannelMap :: MonadIO m => AudioDeviceID -> m (Ptr CInt, CInt)
getAudioDeviceChannelMap devid = liftIO $ do
  countPtr <- malloc
  mapPtr <- getAudioDeviceChannelMapFFI devid countPtr
  count <- peek countPtr
  free countPtr
  return (mapPtr, count)
{-# INLINE getAudioDeviceChannelMap #-}

openAudioDevice :: MonadIO m => AudioDeviceID -> Ptr AudioSpec -> m AudioDeviceID
openAudioDevice devid spec = liftIO $ openAudioDeviceFFI devid spec
{-# INLINE openAudioDevice #-}

isAudioDevicePhysical :: MonadIO m => AudioDeviceID -> m Bool
isAudioDevicePhysical devid = liftIO $ toBool <$> isAudioDevicePhysicalFFI devid
{-# INLINE isAudioDevicePhysical #-}

isAudioDevicePlayback :: MonadIO m => AudioDeviceID -> m Bool
isAudioDevicePlayback devid = liftIO $ toBool <$> isAudioDevicePlaybackFFI devid
{-# INLINE isAudioDevicePlayback #-}

pauseAudioDevice :: MonadIO m => AudioDeviceID -> m Bool
pauseAudioDevice devid = liftIO $ toBool <$> pauseAudioDeviceFFI devid
{-# INLINE pauseAudioDevice #-}

resumeAudioDevice :: MonadIO m => AudioDeviceID -> m Bool
resumeAudioDevice devid = liftIO $ toBool <$> resumeAudioDeviceFFI devid
{-# INLINE resumeAudioDevice #-}

audioDevicePaused :: MonadIO m => AudioDeviceID -> m Bool
audioDevicePaused devid = liftIO $ toBool <$> audioDevicePausedFFI devid
{-# INLINE audioDevicePaused #-}

getAudioDeviceGain :: MonadIO m => AudioDeviceID -> m Float
getAudioDeviceGain devid = liftIO $ realToFrac <$> getAudioDeviceGainFFI devid
{-# INLINE getAudioDeviceGain #-}

setAudioDeviceGain :: MonadIO m => AudioDeviceID -> Float -> m Bool
setAudioDeviceGain devid gain = liftIO $ toBool <$> setAudioDeviceGainFFI devid (realToFrac gain)
{-# INLINE setAudioDeviceGain #-}

closeAudioDevice :: MonadIO m => AudioDeviceID -> m ()
closeAudioDevice devid = liftIO $ closeAudioDeviceFFI devid
{-# INLINE closeAudioDevice #-}

-- Audio stream binding
bindAudioStreams :: MonadIO m => AudioDeviceID -> Ptr (Ptr AudioStream) -> CInt -> m Bool
bindAudioStreams devid streams num_streams = liftIO $ toBool <$> bindAudioStreamsFFI devid streams num_streams
{-# INLINE bindAudioStreams #-}

bindAudioStream :: MonadIO m => AudioDeviceID -> Ptr AudioStream -> m Bool
bindAudioStream devid stream = liftIO $ toBool <$> bindAudioStreamFFI devid stream
{-# INLINE bindAudioStream #-}

unbindAudioStreams :: MonadIO m => Ptr (Ptr AudioStream) -> CInt -> m ()
unbindAudioStreams streams num_streams = liftIO $ unbindAudioStreamsFFI streams num_streams
{-# INLINE unbindAudioStreams #-}

unbindAudioStream :: MonadIO m => Ptr AudioStream -> m ()
unbindAudioStream stream = liftIO $ unbindAudioStreamFFI stream
{-# INLINE unbindAudioStream #-}

getAudioStreamDevice :: MonadIO m => Ptr AudioStream -> m AudioDeviceID
getAudioStreamDevice stream = liftIO $ getAudioStreamDeviceFFI stream
{-# INLINE getAudioStreamDevice #-}

-- Audio stream management
createAudioStream :: MonadIO m => Ptr AudioSpec -> Ptr AudioSpec -> m (Ptr AudioStream)
createAudioStream src_spec dst_spec = liftIO $ createAudioStreamFFI src_spec dst_spec
{-# INLINE createAudioStream #-}

getAudioStreamProperties :: MonadIO m => Ptr AudioStream -> m PropertiesID
getAudioStreamProperties stream = liftIO $ getAudioStreamPropertiesFFI stream
{-# INLINE getAudioStreamProperties #-}

getAudioStreamFormat :: MonadIO m => Ptr AudioStream -> Ptr AudioSpec -> Ptr AudioSpec -> m Bool
getAudioStreamFormat stream src_spec dst_spec = liftIO $ toBool <$> getAudioStreamFormatFFI stream src_spec dst_spec
{-# INLINE getAudioStreamFormat #-}

setAudioStreamFormat :: MonadIO m => Ptr AudioStream -> Ptr AudioSpec -> Ptr AudioSpec -> m Bool
setAudioStreamFormat stream src_spec dst_spec = liftIO $ toBool <$> setAudioStreamFormatFFI stream src_spec dst_spec
{-# INLINE setAudioStreamFormat #-}

getAudioStreamFrequencyRatio :: MonadIO m => Ptr AudioStream -> m Float
getAudioStreamFrequencyRatio stream = liftIO $ realToFrac <$> getAudioStreamFrequencyRatioFFI stream
{-# INLINE getAudioStreamFrequencyRatio #-}

setAudioStreamFrequencyRatio :: MonadIO m => Ptr AudioStream -> Float -> m Bool
setAudioStreamFrequencyRatio stream ratio = liftIO $ toBool <$> setAudioStreamFrequencyRatioFFI stream (realToFrac ratio)
{-# INLINE setAudioStreamFrequencyRatio #-}

getAudioStreamGain :: MonadIO m => Ptr AudioStream -> m Float
getAudioStreamGain stream = liftIO $ realToFrac <$> getAudioStreamGainFFI stream
{-# INLINE getAudioStreamGain #-}

setAudioStreamGain :: MonadIO m => Ptr AudioStream -> Float -> m Bool
setAudioStreamGain stream gain = liftIO $ toBool <$> setAudioStreamGainFFI stream (realToFrac gain)
{-# INLINE setAudioStreamGain #-}

getAudioStreamInputChannelMap :: MonadIO m => Ptr AudioStream -> m (Ptr CInt, CInt)
getAudioStreamInputChannelMap stream = liftIO $ do
  countPtr <- malloc
  mapPtr <- getAudioStreamInputChannelMapFFI stream countPtr
  count <- peek countPtr
  free countPtr
  return (mapPtr, count)
{-# INLINE getAudioStreamInputChannelMap #-}

getAudioStreamOutputChannelMap :: MonadIO m => Ptr AudioStream -> m (Ptr CInt, CInt)
getAudioStreamOutputChannelMap stream = liftIO $ do
  countPtr <- malloc
  mapPtr <- getAudioStreamOutputChannelMapFFI stream countPtr
  count <- peek countPtr
  free countPtr
  return (mapPtr, count)
{-# INLINE getAudioStreamOutputChannelMap #-}

setAudioStreamInputChannelMap :: MonadIO m => Ptr AudioStream -> Ptr CInt -> CInt -> m Bool
setAudioStreamInputChannelMap stream chmap count = liftIO $ toBool <$> setAudioStreamInputChannelMapFFI stream chmap count
{-# INLINE setAudioStreamInputChannelMap #-}

setAudioStreamOutputChannelMap :: MonadIO m => Ptr AudioStream -> Ptr CInt -> CInt -> m Bool
setAudioStreamOutputChannelMap stream chmap count = liftIO $ toBool <$> setAudioStreamOutputChannelMapFFI stream chmap count
{-# INLINE setAudioStreamOutputChannelMap #-}

putAudioStreamData :: MonadIO m => Ptr AudioStream -> Ptr () -> CInt -> m Bool
putAudioStreamData stream buf len = liftIO $ toBool <$> putAudioStreamDataFFI stream buf len
{-# INLINE putAudioStreamData #-}

getAudioStreamData :: MonadIO m => Ptr AudioStream -> Ptr () -> CInt -> m CInt
getAudioStreamData stream buf len = liftIO $ getAudioStreamDataFFI stream buf len
{-# INLINE getAudioStreamData #-}

getAudioStreamAvailable :: MonadIO m => Ptr AudioStream -> m CInt
getAudioStreamAvailable stream = liftIO $ getAudioStreamAvailableFFI stream
{-# INLINE getAudioStreamAvailable #-}

getAudioStreamQueued :: MonadIO m => Ptr AudioStream -> m CInt
getAudioStreamQueued stream = liftIO $ getAudioStreamQueuedFFI stream
{-# INLINE getAudioStreamQueued #-}

flushAudioStream :: MonadIO m => Ptr AudioStream -> m Bool
flushAudioStream stream = liftIO $ toBool <$> flushAudioStreamFFI stream
{-# INLINE flushAudioStream #-}

clearAudioStream :: MonadIO m => Ptr AudioStream -> m Bool
clearAudioStream stream = liftIO $ toBool <$> clearAudioStreamFFI stream
{-# INLINE clearAudioStream #-}

pauseAudioStreamDevice :: MonadIO m => Ptr AudioStream -> m Bool
pauseAudioStreamDevice stream = liftIO $ toBool <$> pauseAudioStreamDeviceFFI stream
{-# INLINE pauseAudioStreamDevice #-}

resumeAudioStreamDevice :: MonadIO m => Ptr AudioStream -> m Bool
resumeAudioStreamDevice stream = liftIO $ toBool <$> resumeAudioStreamDeviceFFI stream
{-# INLINE resumeAudioStreamDevice #-}

audioStreamDevicePaused :: MonadIO m => Ptr AudioStream -> m Bool
audioStreamDevicePaused stream = liftIO $ toBool <$> audioStreamDevicePausedFFI stream
{-# INLINE audioStreamDevicePaused #-}

lockAudioStream :: MonadIO m => Ptr AudioStream -> m Bool
lockAudioStream stream = liftIO $ toBool <$> lockAudioStreamFFI stream
{-# INLINE lockAudioStream #-}

unlockAudioStream :: MonadIO m => Ptr AudioStream -> m Bool
unlockAudioStream stream = liftIO $ toBool <$> unlockAudioStreamFFI stream
{-# INLINE unlockAudioStream #-}

-- Audio stream callbacks are complex and will need to be wrapped carefully
-- Here's a basic implementation for setting callbacks
setAudioStreamGetCallback :: MonadIO m => Ptr AudioStream -> Maybe (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()) -> Ptr () -> m Bool
setAudioStreamGetCallback stream Nothing userdata = liftIO $ toBool <$> setAudioStreamGetCallbackFFI stream nullFunPtr userdata
setAudioStreamGetCallback stream (Just callback) userdata = liftIO $ do
  callbackPtr <- mkAudioStreamCallback callback
  result <- toBool <$> setAudioStreamGetCallbackFFI stream callbackPtr userdata
  -- In a real implementation, you'd need to handle the lifecycle of this function pointer
  -- This might leak memory if called multiple times
  return result
{-# INLINE setAudioStreamGetCallback #-}

setAudioStreamPutCallback :: MonadIO m => Ptr AudioStream -> Maybe (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()) -> Ptr () -> m Bool
setAudioStreamPutCallback stream Nothing userdata = liftIO $ toBool <$> setAudioStreamPutCallbackFFI stream nullFunPtr userdata
setAudioStreamPutCallback stream (Just callback) userdata = liftIO $ do
  callbackPtr <- mkAudioStreamCallback callback
  result <- toBool <$> setAudioStreamPutCallbackFFI stream callbackPtr userdata
  -- In a real implementation, you'd need to handle the lifecycle of this function pointer
  -- This might leak memory if called multiple times
  return result
{-# INLINE setAudioStreamPutCallback #-}

destroyAudioStream :: MonadIO m => Ptr AudioStream -> m ()
destroyAudioStream stream = liftIO $ destroyAudioStreamFFI stream
{-# INLINE destroyAudioStream #-}

openAudioDeviceStream :: MonadIO m => AudioDeviceID -> Ptr AudioSpec -> Maybe (Ptr () -> Ptr AudioStream -> CInt -> CInt -> IO ()) -> Ptr () -> m (Ptr AudioStream)
openAudioDeviceStream devid spec Nothing userdata = liftIO $ openAudioDeviceStreamFFI devid spec nullFunPtr userdata
openAudioDeviceStream devid spec (Just callback) userdata = liftIO $ do
  callbackPtr <- mkAudioStreamCallback callback
  -- Again, in a real implementation, you'd need to handle the lifecycle of this function pointer
  openAudioDeviceStreamFFI devid spec callbackPtr userdata
{-# INLINE openAudioDeviceStream #-}

-- Audio postmix callback
setAudioPostmixCallback :: MonadIO m => AudioDeviceID -> Maybe (Ptr () -> Ptr AudioSpec -> Ptr CFloat -> CInt -> IO ()) -> Ptr () -> m Bool
setAudioPostmixCallback devid Nothing userdata = liftIO $ toBool <$> setAudioPostmixCallbackFFI devid nullFunPtr userdata
setAudioPostmixCallback devid (Just callback) userdata = liftIO $ do
  callbackPtr <- mkAudioPostmixCallback callback
  result <- toBool <$> setAudioPostmixCallbackFFI devid callbackPtr userdata
  -- In a real implementation, you'd need to handle the lifecycle of this function pointer
  return result
{-# INLINE setAudioPostmixCallback #-}

-- WAV and utility functions
loadWAV_IO :: MonadIO m => Ptr IOStream -> Bool -> Ptr AudioSpec -> Ptr (Ptr Word8) -> Ptr Word32 -> m Bool
loadWAV_IO src closeio spec audio_buf audio_len = liftIO $ 
  toBool <$> loadWAV_IOFFI src (fromBool closeio) spec audio_buf audio_len
{-# INLINE loadWAV_IO #-}

loadWAV :: MonadIO m => CString -> Ptr AudioSpec -> Ptr (Ptr Word8) -> Ptr Word32 -> m Bool
loadWAV path spec audio_buf audio_len = liftIO $ 
  toBool <$> loadWAVFFI path spec audio_buf audio_len
{-# INLINE loadWAV #-}

mixAudio :: MonadIO m => Ptr Word8 -> Ptr Word8 -> AudioFormat -> Word32 -> Float -> m Bool
mixAudio dst src format len volume = liftIO $ 
  toBool <$> mixAudioFFI dst src format len (realToFrac volume)
{-# INLINE mixAudio #-}

convertAudioSamples :: MonadIO m => Ptr AudioSpec -> Ptr Word8 -> CInt -> Ptr AudioSpec -> Ptr (Ptr Word8) -> Ptr CInt -> m Bool
convertAudioSamples src_spec src_data src_len dst_spec dst_data dst_len = liftIO $ 
  toBool <$> convertAudioSamplesFFI src_spec src_data src_len dst_spec dst_data dst_len
{-# INLINE convertAudioSamples #-}

getAudioFormatName :: MonadIO m => AudioFormat -> m CString
getAudioFormatName format = liftIO $ getAudioFormatNameFFI format
{-# INLINE getAudioFormatName #-}

getSilenceValueForFormat :: MonadIO m => AudioFormat -> m CInt
getSilenceValueForFormat format = liftIO $ getSilenceValueForFormatFFI format
{-# INLINE getSilenceValueForFormat #-}

-- Helper functions
toBool :: CBool -> Bool
toBool = (/= 0)

fromBool :: Bool -> CBool
fromBool True = 1
fromBool False = 0
