{-# LANGUAGE CPP #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module SDL.Input.Joystick
  ( numJoysticks
  , availableJoysticks
  , JoystickDevice(..)

  , openJoystick
  , closeJoystick

  , getJoystickID
  , Joystick
  , JoyButtonState(..)
  , buttonPressed
  , ballDelta
  , axisPosition
  , numAxes
  , numButtons
  , numBalls
  , JoyHatPosition(..)
  , getHat
  , numHats
  , JoyDeviceConnection(..)

  -- New SDL3-specific functions
  , getJoystickName
  , getJoystickType
  , getJoystickGUID
  , rumbleJoystick
  , setJoystickLED
  , getJoystickConnectionState
  , getJoystickPowerInfo
  ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Data (Data)
import Data.Int (Int16)
import Data.Text (Text)
import Data.Traversable (for)
import Data.Typeable
import Data.Word (Word8, Word16, Word32)
import Foreign.C.Types (CInt(..))
import Foreign.Marshal.Alloc (alloca)
import Foreign.Marshal.Array (peekArray)
import Foreign.Ptr (Ptr, nullPtr)
import Foreign.Storable
import GHC.Generics (Generic)
import SDL.Vect
import SDL.Internal.Exception
import SDL.Internal.Types
import SDL.Internal.Numbered
import qualified Data.ByteString as BS
import qualified Data.Text.Encoding as Text
import qualified Data.Vector as V
import qualified SDL.Raw.Joystick as Raw
import qualified SDL.Raw.Types as RawTypes
import qualified SDL.Raw.Enum as RawEnum
import qualified SDL.Raw.Basic

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative
#endif

-- | A description of a joystick that can be opened using 'openJoystick'.
data JoystickDevice = JoystickDevice
  { joystickDeviceName :: Text
  , joystickDeviceId :: RawTypes.JoystickID -- Updated to Uint32
  } deriving (Eq, Generic, Read, Ord, Show, Typeable)

-- | Identifies the state of a joystick button.
data JoyButtonState = JoyButtonPressed | JoyButtonReleased
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

-- | Count the number of joysticks attached to the system.
numJoysticks :: MonadIO m => m Int
numJoysticks = liftIO $ do
  count <- alloca $ \ptr -> do
    _ <- Raw.getJoysticks ptr
    peek ptr
  return $ fromIntegral count

-- | Enumerate all connected joysticks, retrieving a description of each.
availableJoysticks :: MonadIO m => m (V.Vector JoystickDevice)
availableJoysticks = liftIO $ do
  alloca $ \countPtr -> do
    joystickIds <- Raw.getJoysticks countPtr
    if joystickIds == nullPtr
      then return V.empty -- No joysticks or error occurred
      else do
        count <- peek countPtr
        ids <- peekArray (fromIntegral count) joystickIds
        free joystickIds -- Free the array returned by SDL_GetJoysticks
        fmap V.fromList $ for ids $ \joystickId -> do
          cstr <- throwIfNull "SDL.Input.Joystick.availableJoysticks" "SDL_GetJoystickNameForID" $
            Raw.getJoystickNameForID joystickId
          name <- Text.decodeUtf8 <$> BS.packCString cstr
          return $ JoystickDevice name joystickId

-- | Open a joystick for use.
openJoystick :: (Functor m, MonadIO m) => JoystickDevice -> m Joystick
openJoystick (JoystickDevice _ x) = fmap Joystick $
  throwIfNull "SDL.Input.Joystick.openJoystick" "SDL_OpenJoystick" $
  Raw.openJoystick x

-- | Close a previously opened joystick.
closeJoystick :: MonadIO m => Joystick -> m ()
closeJoystick (Joystick j) = Raw.closeJoystick j

-- | Get the instance ID of an opened joystick.
getJoystickID :: MonadIO m => Joystick -> m RawTypes.JoystickID
getJoystickID (Joystick j) = Raw.getJoystickID j

-- | Determine if a given button is currently held.
buttonPressed :: (Functor m, MonadIO m) => Joystick -> CInt -> m JoyButtonState
buttonPressed (Joystick j) buttonIndex = do
  pressed <- Raw.getJoystickButton j buttonIndex
  return $ if pressed then JoyButtonPressed else JoyButtonReleased

-- | Get the ball axis change since the last poll.
ballDelta :: MonadIO m => Joystick -> CInt -> m (V2 CInt)
ballDelta (Joystick j) ballIndex = liftIO $
  alloca $ \xptr ->
  alloca $ \yptr -> do
    throwIf_ (not) "SDL.Input.Joystick.ballDelta" "SDL_GetJoystickBall" $
      Raw.getJoystickBall j ballIndex xptr yptr
    V2 <$> peek xptr <*> peek yptr

-- | Get the current state of an axis control on a joystick.
axisPosition :: MonadIO m => Joystick -> CInt -> m Int16
axisPosition (Joystick j) axisIndex = Raw.getJoystickAxis j axisIndex

-- | Get the number of general axis controls on a joystick.
numAxes :: MonadIO m => Joystick -> m CInt
numAxes (Joystick j) = liftIO $
  throwIfNeg "SDL.Input.Joystick.numAxes" "SDL_GetNumJoystickAxes" $
  Raw.getNumJoystickAxes j

-- | Get the number of buttons on a joystick.
numButtons :: MonadIO m => Joystick -> m CInt
numButtons (Joystick j) = liftIO $
  throwIfNeg "SDL.Input.Joystick.numButtons" "SDL_GetNumJoystickButtons" $
  Raw.getNumJoystickButtons j

-- | Get the number of trackballs on a joystick.
numBalls :: MonadIO m => Joystick -> m CInt
numBalls (Joystick j) = liftIO $
  throwIfNeg "SDL.Input.Joystick.numBalls" "SDL_GetNumJoystickBalls" $
  Raw.getNumJoystickBalls j

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

-- | Get current position of a POV hat on a joystick.
getHat :: (Functor m, MonadIO m) => Joystick -> CInt -> m JoyHatPosition
getHat (Joystick j) hatIndex = fromNumber <$> Raw.getJoystickHat j hatIndex

-- | Get the number of POV hats on a joystick.
numHats :: MonadIO m => Joystick -> m CInt
numHats (Joystick j) = liftIO $
  throwIfNeg "SDL.Input.Joystick.numHats" "SDL_GetNumJoystickHats" $
  Raw.getNumJoystickHats j

-- | Identifies whether a joystick has been connected or disconnected.
data JoyDeviceConnection = JoyDeviceAdded | JoyDeviceRemoved
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

-- Note: SDL3 events would need to be handled separately; this is a placeholder.
instance FromNumber JoyDeviceConnection Word32 where
  fromNumber n = case n of
    0x4006 -> JoyDeviceAdded  -- SDL_JOYDEVICEADDED (SDL3 event code TBD)
    0x4007 -> JoyDeviceRemoved -- SDL_JOYDEVICEREMOVED (SDL3 event code TBD)
    _ -> JoyDeviceAdded

-- | Get the implementation-dependent name of a joystick.
getJoystickName :: MonadIO m => Joystick -> m Text
getJoystickName (Joystick j) = liftIO $ do
  cstr <- throwIfNull "SDL.Input.Joystick.getJoystickName" "SDL_GetJoystickName" $
    Raw.getJoystickName j
  Text.decodeUtf8 <$> BS.packCString cstr

-- | Get the type of an opened joystick.
getJoystickType :: MonadIO m => Joystick -> m RawEnum.JoystickType
getJoystickType (Joystick j) = Raw.getJoystickType j

-- | Get the implementation-dependent GUID for the joystick.
getJoystickGUID :: MonadIO m => Joystick -> m RawTypes.JoystickGUID
getJoystickGUID (Joystick j) = liftIO $ do
  guidPtr <- Raw.getJoystickGUID j
  peek guidPtr

-- | Start a rumble effect on the joystick.
rumbleJoystick :: MonadIO m => Joystick -> Word16 -> Word16 -> Word32 -> m Bool
rumbleJoystick (Joystick j) lowFreq highFreq duration =
  Raw.rumbleJoystick j lowFreq highFreq duration

-- | Update the joystick's LED color.
setJoystickLED :: MonadIO m => Joystick -> Word8 -> Word8 -> Word8 -> m Bool
setJoystickLED (Joystick j) red green blue = Raw.setJoystickLED j red green blue

-- | Get the connection state of a joystick.
getJoystickConnectionState :: MonadIO m => Joystick -> m RawEnum.JoystickConnectionState
getJoystickConnectionState (Joystick j) = Raw.getJoystickConnectionState j

-- | Get the battery state of a joystick.
getJoystickPowerInfo :: MonadIO m => Joystick -> m (RawEnum.PowerState, Maybe Int)
getJoystickPowerInfo (Joystick j) = liftIO $
  alloca $ \percentPtr -> do
    state <- Raw.getJoystickPowerInfo j percentPtr
    percent <- peek percentPtr
    return (state, if percent >= 0 then Just (fromIntegral percent) else Nothing)

-- | Free memory allocated by SDL functions (e.g., SDL_GetJoysticks).
foreign import ccall unsafe "SDL_free" free :: Ptr a -> IO ()
