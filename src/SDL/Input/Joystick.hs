{-# LANGUAGE CPP #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module SDL.Input.Joystick
  ( numJoysticks,
    availableJoysticks,
    JoystickDevice (..),
    openJoystick,
    closeJoystick,
    getJoystickID,
    Joystick,
    JoyButtonState (..),
    buttonPressed,
    ballDelta,
    axisPosition,
    numAxes,
    numButtons,
    numBalls,
    JoyHatPosition (..),
    getHat,
    numHats,
    JoyDeviceConnection (..),
    -- New SDL3-specific functions
    getJoystickName,
    getJoystickType,
    getJoystickGUID,
    rumbleJoystick,
    setJoystickLED,
    getJoystickConnectionState,
    getJoystickPowerInfo,
  )
where

import Control.Monad (when)
import Control.Monad.IO.Class (MonadIO, liftIO)
import qualified Data.ByteString as BS
import Data.Data (Data)
import Data.Int (Int16)
import Data.Text (Text)
import qualified Data.Text.Encoding as Text
import Data.Traversable (for)
import Data.Typeable
import qualified Data.Vector as V
import Data.Word (Word16, Word32, Word8)
import Foreign.C.Types (CInt (..))
import Foreign.ForeignPtr (withForeignPtr, newForeignPtr)
import Foreign.Marshal.Alloc (alloca)
import Foreign.Marshal.Array (peekArray)
import Foreign.Ptr (Ptr, FunPtr, castPtr, nullPtr)
import Foreign.Storable
import GHC.Generics (Generic)
import SDL.Internal.Exception
import SDL.Internal.Numbered
import SDL.Internal.Types
import qualified SDL.Raw.Basic
import qualified SDL.Raw.Enum as RawEnum
import qualified SDL.Raw.Joystick as Raw
import qualified SDL.Raw.Types as RawTypes
import SDL.Vect

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative
#endif

-- | A description of a joystick that can be opened using 'openJoystick'.
data JoystickDevice = JoystickDevice
  { joystickDeviceName :: Text,
    joystickDeviceId :: RawTypes.JoystickID -- Updated to Uint32
  }
  deriving (Eq, Generic, Read, Ord, Show, Typeable)

-- | Identifies the state of a joystick button.
data JoyButtonState = JoyButtonPressed | JoyButtonReleased
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

-- | Identifies the state of the POV hat on a joystick.
data JoyHatPosition
  = HatCentered
  | HatUp
  | HatRight
  | HatDown
  | HatLeft
  | HatRightUp
  | HatRightDown
  | HatLeftUp
  | HatLeftDown
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

instance FromNumber JoyHatPosition Word8 where
  fromNumber n = case n of
    RawEnum.SDL_HAT_CENTERED -> HatCentered
    RawEnum.SDL_HAT_UP -> HatUp
    RawEnum.SDL_HAT_RIGHT -> HatRight
    RawEnum.SDL_HAT_DOWN -> HatDown
    RawEnum.SDL_HAT_LEFT -> HatLeft
    RawEnum.SDL_HAT_RIGHTUP -> HatRightUp
    RawEnum.SDL_HAT_RIGHTDOWN -> HatRightDown
    RawEnum.SDL_HAT_LEFTUP -> HatLeftUp
    RawEnum.SDL_HAT_LEFTDOWN -> HatLeftDown
    _ -> HatCentered

numJoysticks :: (MonadIO m) => m Int
numJoysticks = liftIO $ do
  count <- alloca $ \ptr -> do
    _ <- Raw.getJoysticks ptr
    peek ptr
  return $ fromIntegral count

availableJoysticks :: (MonadIO m) => m (V.Vector JoystickDevice)
availableJoysticks = liftIO $ do
  alloca $ \countPtr -> do
    joystickIds <- Raw.getJoysticks countPtr
    if joystickIds == nullPtr
      then return V.empty
      else do
        count <- peek countPtr
        ids <- peekArray (fromIntegral count) joystickIds
        free joystickIds
        fmap V.fromList $ for ids $ \joystickId -> do
          cstr <-
            throwIfNull "SDL.Input.Joystick.availableJoysticks" "SDL_GetJoystickNameForID" $
              Raw.getJoystickNameForID joystickId
          name <- Text.decodeUtf8 <$> BS.packCString cstr
          return $ JoystickDevice name joystickId

openJoystick :: (Functor m, MonadIO m) => JoystickDevice -> m Joystick
openJoystick (JoystickDevice _ x) = liftIO $ do
  ptr <-
    throwIfNull "SDL.Input.Joystick.openJoystick" "SDL_OpenJoystick" $
      Raw.openJoystick x
  Joystick <$> newForeignPtr Raw.finalizeJoystick (castPtr ptr) -- Create a ForeignPtr from the raw pointer

closeJoystick :: (MonadIO m) => Joystick -> m ()
closeJoystick (Joystick j) =
  liftIO $
    withForeignPtr j $ \ptr -> when (ptr /= nullPtr) $ Raw.closeJoystick ptr

getJoystickID :: (MonadIO m) => Joystick -> m RawTypes.JoystickID
getJoystickID (Joystick j) =
  liftIO $
    withForeignPtr j Raw.getJoystickID

buttonPressed :: (Functor m, MonadIO m) => Joystick -> CInt -> m JoyButtonState
buttonPressed (Joystick j) buttonIndex = liftIO $
  withForeignPtr j $ \ptr -> do
    pressed <- Raw.getJoystickButton ptr buttonIndex
    return $ if pressed then JoyButtonPressed else JoyButtonReleased

ballDelta :: (MonadIO m) => Joystick -> CInt -> m (V2 CInt)
ballDelta (Joystick j) ballIndex = liftIO $
  withForeignPtr j $ \ptr ->
    alloca $ \xptr ->
      alloca $ \yptr -> do
        throwIf_ (not) "SDL.Input.Joystick.ballDelta" "SDL_GetJoystickBall" $
          Raw.getJoystickBall ptr ballIndex xptr yptr
        V2 <$> peek xptr <*> peek yptr

axisPosition :: (MonadIO m) => Joystick -> CInt -> m Int16
axisPosition (Joystick j) axisIndex = liftIO $
  withForeignPtr j $
    \ptr -> Raw.getJoystickAxis ptr axisIndex

numAxes :: (MonadIO m) => Joystick -> m CInt
numAxes (Joystick j) = liftIO $
  withForeignPtr j $ \ptr ->
    throwIfNeg "SDL.Input.Joystick.numAxes" "SDL_GetNumJoystickAxes" $
      Raw.getNumJoystickAxes ptr

numButtons :: (MonadIO m) => Joystick -> m CInt
numButtons (Joystick j) = liftIO $
  withForeignPtr j $ \ptr ->
    throwIfNeg "SDL.Input.Joystick.numButtons" "SDL_GetNumJoystickButtons" $
      Raw.getNumJoystickButtons ptr

numBalls :: (MonadIO m) => Joystick -> m CInt
numBalls (Joystick j) = liftIO $
  withForeignPtr j $ \ptr ->
    throwIfNeg "SDL.Input.Joystick.numBalls" "SDL_GetNumJoystickBalls" $
      Raw.getNumJoystickBalls ptr

getHat :: (Functor m, MonadIO m) => Joystick -> CInt -> m JoyHatPosition
getHat (Joystick j) hatIndex = liftIO $
  withForeignPtr j $
    \ptr -> fromNumber <$> Raw.getJoystickHat ptr hatIndex

numHats :: (MonadIO m) => Joystick -> m CInt
numHats (Joystick j) = liftIO $
  withForeignPtr j $ \ptr ->
    throwIfNeg "SDL.Input.Joystick.numHats" "SDL_GetNumJoystickHats" $
      Raw.getNumJoystickHats ptr

-- | Identifies whether a joystick has been connected or disconnected.
data JoyDeviceConnection = JoyDeviceAdded | JoyDeviceRemoved
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

-- Note: SDL3 events would need to be handled separately; this is a placeholder.
instance FromNumber JoyDeviceConnection Word32 where
  fromNumber n = case n of
    0x4006 -> JoyDeviceAdded  -- SDL_JOYDEVICEADDED (SDL3 event code TBD)
    0x4007 -> JoyDeviceRemoved -- SDL_JOYDEVICEREMOVED (SDL3 event code TBD)
    _ -> JoyDeviceAdded

getJoystickName :: (MonadIO m) => Joystick -> m Text
getJoystickName (Joystick j) = liftIO $
  withForeignPtr j $ \ptr -> do
    cstr <-
      throwIfNull "SDL.Input.Joystick.getJoystickName" "SDL_GetJoystickName" $
        Raw.getJoystickName ptr
    Text.decodeUtf8 <$> BS.packCString cstr

getJoystickType :: (MonadIO m) => Joystick -> m RawEnum.JoystickType
getJoystickType (Joystick j) =
  liftIO $
    withForeignPtr j Raw.getJoystickType

getJoystickGUID :: (MonadIO m) => Joystick -> m RawTypes.GUID
getJoystickGUID (Joystick j) = liftIO $
  withForeignPtr j $ \ptr -> do
    guidPtr <- Raw.getJoystickGUID ptr
    peek guidPtr

rumbleJoystick :: (MonadIO m) => Joystick -> Word16 -> Word16 -> Word32 -> m Bool
rumbleJoystick (Joystick j) lowFreq highFreq duration = liftIO $
  withForeignPtr j $
    \ptr -> Raw.rumbleJoystick ptr lowFreq highFreq duration

setJoystickLED :: (MonadIO m) => Joystick -> Word8 -> Word8 -> Word8 -> m Bool
setJoystickLED (Joystick j) red green blue = liftIO $
  withForeignPtr j $
    \ptr -> Raw.setJoystickLED ptr red green blue

getJoystickConnectionState :: (MonadIO m) => Joystick -> m RawEnum.JoystickConnectionState
getJoystickConnectionState (Joystick j) =
  liftIO $
    withForeignPtr j Raw.getJoystickConnectionState

getJoystickPowerInfo :: (MonadIO m) => Joystick -> m (RawEnum.PowerState, Maybe Int)
getJoystickPowerInfo (Joystick j) = liftIO $
  withForeignPtr j $ \ptr ->
    alloca $ \percentPtr -> do
      state <- Raw.getJoystickPowerInfo ptr percentPtr
      percent <- peek percentPtr
      return (state, if percent >= 0 then Just (fromIntegral percent) else Nothing)

foreign import ccall unsafe "SDL_free" free :: Ptr a -> IO ()
