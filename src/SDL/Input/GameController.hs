{-# LANGUAGE CPP #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PatternSynonyms #-}

module SDL.Input.GameController
  ( ControllerDevice (..)
  , availableControllers

  , openController
  , closeController
  , controllerAttached

  , getControllerID

  , controllerMapping
  , addControllerMapping
  , addControllerMappingsFromFile

  , ControllerButton (..)
  , ControllerButtonState (..)
  , controllerButton

  , ControllerAxis (..)
  , controllerAxis
  
  , ControllerDeviceConnection (..)
  ) where

import Control.Monad (filterM)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Data (Data)
import Data.Int
import Data.Text (Text)
import Data.Traversable (for)
import Data.Typeable
import Data.Word
import Foreign.C (withCString)
import Foreign.C.Types
import Foreign.ForeignPtr
import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable
import GHC.Generics (Generic)
import GHC.Int (Int32)
import SDL.Input.Joystick (numJoysticks)
import SDL.Internal.Exception
import SDL.Internal.Numbered
import SDL.Internal.Types
import SDL.Vect
import qualified Data.ByteString as BS
import qualified Data.ByteString.Internal as BSI
import qualified SDL.Raw as Raw
import qualified Data.Text.Encoding as Text
import qualified Data.Vector as V

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative
#endif

{- | A description of game controller that can be opened using 'openController'.
 To retrieve a list of connected game controllers, use 'availableControllers'.
-}
data ControllerDevice = ControllerDevice
  { gameControllerDeviceName :: Text
  , gameControllerDeviceId :: CInt
  }
  deriving (Eq, Generic, Read, Ord, Show, Typeable)

-- | Enumerate all connected Controllers, retrieving a description of each.
availableControllers :: MonadIO m => m (V.Vector ControllerDevice)
availableControllers = liftIO $ do
  n <- numJoysticks
  indices <- filterM Raw.isGameController [0 .. (n - 1)]
  fmap V.fromList $ for indices $ \i -> do
    cstr <-
      throwIfNull "SDL.Input.Controller.availableGameControllers" "SDL_GameControllerNameForIndex" $
        Raw.gameControllerNameForIndex i
    name <- Text.decodeUtf8 <$> BS.packCString cstr
    return (ControllerDevice name i)

{- | Open a controller so that you can start receiving events from interaction with this controller.

 See @<https://wiki.libsdl.org/SDL_OpenGamepad SDL_OpenGamepad>@ for C documentation.
-}
openController
  :: (Functor m, MonadIO m)
  => ControllerDevice
  -- ^ The device to open. Use 'availableControllers' to find 'JoystickDevices's
  -> m GameController
openController (ControllerDevice _ x) =
  fmap GameController $
    throwIfNull "SDL.Input.GameController.openController" "SDL_OpenGamepad" $
      Raw.gameControllerOpen x

{- | Close a controller previously opened with 'openController'.

 See @<https://wiki.libsdl.org/SDL_CloseGamepad SDL_CloseGamepad>@ for C documentation.
-}
closeController :: MonadIO m => GameController -> m ()
closeController (GameController j) = Raw.gameControllerClose j

{- | Check if a controller has been opened and is currently connected.

 See @<https://wiki.libsdl.org/SDL_GamepadConnected SDL_GamepadConnected>@ for C documentation.
-}
controllerAttached :: MonadIO m => GameController -> m Bool
controllerAttached (GameController c) = Raw.gameControllerGetAttached c

{- | Get the instance ID of an opened controller. The instance ID is used to identify the controller
 in future SDL events.

 See @<https://wiki.libsdl.org/SDL_GameControllerInstanceID SDL_GameControllerInstanceID>@ for C documentation.
-}
getControllerID :: MonadIO m => GameController -> m Int32
getControllerID (GameController c) =
  throwIfNeg "SDL.Input.GameController.getControllerID" "SDL_GetJoystickID" $
    Raw.joystickInstanceID c

{- | Get the current mapping of a Game Controller.

 See @<https://wiki.libsdl.org/SDL_GetGamepadMapping SDL_GetGamepadMapping>@ for C documentation.
-}
controllerMapping :: MonadIO m => GameController -> m Text
controllerMapping (GameController c) = liftIO $ do
  mapping <-
    throwIfNull "SDL.Input.GameController.getControllerMapping" "SDL_GetGamepadMapping" $
      Raw.gameControllerMapping c
  Text.decodeUtf8 <$> BS.packCString mapping

{- | Add support for controllers that SDL is unaware of or to cause an existing controller to
 have a different binding.

 See @<https://wiki.libsdl.org/SDL_AddGamepadMapping SDL_AddGamepadMapping>@ for C documentation.
-}
addControllerMapping :: MonadIO m => BS.ByteString -> m ()
addControllerMapping mapping =
  liftIO $
    throwIfNeg_ "SDL.Input.GameController.addControllerMapping" "SDL_AddGamepadMapping" $
      let (mappingForeign, _, _) = BSI.toForeignPtr mapping
       in withForeignPtr mappingForeign $ \mappingPtr ->
            Raw.gameControllerAddMapping (castPtr mappingPtr)

{- | Use this function to load a set of Game Controller mappings from a file, filtered by the
 current SDL_GetPlatform(). A community sourced database of controllers is available
 @<https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt here>@
 (on GitHub).

 See @<https://wiki.libsdl.org/SDL_AddGamepadMappingsFromFile SDL_AddGamepadMappingsFromFile>@ for C documentation.
-}
addControllerMappingsFromFile :: MonadIO m => FilePath -> m ()
addControllerMappingsFromFile mappingFile =
  liftIO $
    throwIfNeg_ "SDL.Input.GameController.addControllerMappingsFromFile" "SDL_AddGamepadMappingsFromFile" $
      withCString mappingFile Raw.gameControllerAddMappingsFromFile

{- | Get the current state of an axis control on a game controller.

 See @<https://wiki.libsdl.org/SDL_GetGamepadAxis SDL_GetGamepadAxis>@ for C documentation.
-}
controllerAxis :: MonadIO m => GameController -> ControllerAxis -> m Int16
controllerAxis (GameController c) axis =
  Raw.gameControllerGetAxis c (toNumber axis)

{- | Get the current state of a button on a game controller.

 See @<https://wiki.libsdl.org/SDL_GetGamepadButton SDL_GetGamepadButton>@ for C documentation.
-}
controllerButton :: MonadIO m => GameController -> ControllerButton -> m ControllerButtonState
controllerButton (GameController c) button =
  fromNumber . fromIntegral <$> Raw.gameControllerGetButton c (toNumber button)

-- | Identifies a gamepad button.
data ControllerButton
  = ControllerButtonInvalid
  | ControllerButtonA
  | ControllerButtonB
  | ControllerButtonX
  | ControllerButtonY
  | ControllerButtonBack
  | ControllerButtonGuide
  | ControllerButtonStart
  | ControllerButtonLeftStick
  | ControllerButtonRightStick
  | ControllerButtonLeftShoulder
  | ControllerButtonRightShoulder
  | ControllerButtonDpadUp
  | ControllerButtonDpadDown
  | ControllerButtonDpadLeft
  | ControllerButtonDpadRight
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

instance FromNumber ControllerButton Int32 where
  fromNumber n = case n of
    Raw.SDL_GAMEPAD_BUTTON_SOUTH -> ControllerButtonA
    Raw.SDL_GAMEPAD_BUTTON_EAST -> ControllerButtonB
    Raw.SDL_GAMEPAD_BUTTON_WEST -> ControllerButtonX
    Raw.SDL_GAMEPAD_BUTTON_NORTH -> ControllerButtonY
    Raw.SDL_GAMEPAD_BUTTON_BACK -> ControllerButtonBack
    Raw.SDL_GAMEPAD_BUTTON_GUIDE -> ControllerButtonGuide
    Raw.SDL_GAMEPAD_BUTTON_START -> ControllerButtonStart
    Raw.SDL_GAMEPAD_BUTTON_LEFT_STICK -> ControllerButtonLeftStick
    Raw.SDL_GAMEPAD_BUTTON_RIGHT_STICK -> ControllerButtonRightStick
    Raw.SDL_GAMEPAD_BUTTON_LEFT_SHOULDER -> ControllerButtonLeftShoulder
    Raw.SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER -> ControllerButtonRightShoulder
    Raw.SDL_GAMEPAD_BUTTON_DPAD_UP -> ControllerButtonDpadUp
    Raw.SDL_GAMEPAD_BUTTON_DPAD_DOWN -> ControllerButtonDpadDown
    Raw.SDL_GAMEPAD_BUTTON_DPAD_LEFT -> ControllerButtonDpadLeft
    Raw.SDL_GAMEPAD_BUTTON_DPAD_RIGHT -> ControllerButtonDpadRight
    _ -> ControllerButtonInvalid

instance ToNumber ControllerButton Int32 where
  toNumber c = case c of
    ControllerButtonA -> Raw.SDL_GAMEPAD_BUTTON_SOUTH
    ControllerButtonB -> Raw.SDL_GAMEPAD_BUTTON_EAST
    ControllerButtonX -> Raw.SDL_GAMEPAD_BUTTON_WEST
    ControllerButtonY -> Raw.SDL_GAMEPAD_BUTTON_NORTH
    ControllerButtonBack -> Raw.SDL_GAMEPAD_BUTTON_BACK
    ControllerButtonGuide -> Raw.SDL_GAMEPAD_BUTTON_GUIDE
    ControllerButtonStart -> Raw.SDL_GAMEPAD_BUTTON_START
    ControllerButtonLeftStick -> Raw.SDL_GAMEPAD_BUTTON_LEFT_STICK
    ControllerButtonRightStick -> Raw.SDL_GAMEPAD_BUTTON_RIGHT_STICK
    ControllerButtonLeftShoulder -> Raw.SDL_GAMEPAD_BUTTON_LEFT_SHOULDER
    ControllerButtonRightShoulder -> Raw.SDL_GAMEPAD_BUTTON_RIGHT_SHOULDER
    ControllerButtonDpadUp -> Raw.SDL_GAMEPAD_BUTTON_DPAD_UP
    ControllerButtonDpadDown -> Raw.SDL_GAMEPAD_BUTTON_DPAD_DOWN
    ControllerButtonDpadLeft -> Raw.SDL_GAMEPAD_BUTTON_DPAD_LEFT
    ControllerButtonDpadRight -> Raw.SDL_GAMEPAD_BUTTON_DPAD_RIGHT
    ControllerButtonInvalid -> Raw.SDL_GAMEPAD_BUTTON_INVALID

-- | Identifies the state of a controller button.
data ControllerButtonState
  = ControllerButtonPressed
  | ControllerButtonReleased
  | ControllerButtonInvalidState
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

instance FromNumber ControllerButtonState Word32 where
  fromNumber n = case n of
    Raw.SDL_EVENT_GAMEPAD_BUTTON_DOWN -> ControllerButtonPressed
    Raw.SDL_EVENT_GAMEPAD_BUTTON_UP -> ControllerButtonReleased
    _ -> ControllerButtonInvalidState

data ControllerAxis
  = ControllerAxisInvalid
  | ControllerAxisLeftX
  | ControllerAxisLeftY
  | ControllerAxisRightX
  | ControllerAxisRightY
  | ControllerAxisTriggerLeft
  | ControllerAxisTriggerRight
  | ControllerAxisMax
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

instance ToNumber ControllerAxis Int32 where
  toNumber a = case a of
    ControllerAxisLeftX -> Raw.SDL_GAMEPAD_AXIS_LEFTX
    ControllerAxisLeftY -> Raw.SDL_GAMEPAD_AXIS_LEFTY
    ControllerAxisRightX -> Raw.SDL_GAMEPAD_AXIS_RIGHTX
    ControllerAxisRightY -> Raw.SDL_GAMEPAD_AXIS_RIGHTY
    ControllerAxisTriggerLeft -> Raw.SDL_GAMEPAD_AXIS_LEFT_TRIGGER
    ControllerAxisTriggerRight -> Raw.SDL_GAMEPAD_AXIS_RIGHT_TRIGGER
    ControllerAxisMax -> Raw.SDL_GAMEPAD_AXIS_COUNT
    ControllerAxisInvalid -> Raw.SDL_GAMEPAD_AXIS_INVALID

instance FromNumber ControllerAxis Int32 where
  fromNumber n = case n of
    Raw.SDL_GAMEPAD_AXIS_LEFTX -> ControllerAxisLeftX
    Raw.SDL_GAMEPAD_AXIS_LEFTY -> ControllerAxisLeftY
    Raw.SDL_GAMEPAD_AXIS_RIGHTX -> ControllerAxisRightX
    Raw.SDL_GAMEPAD_AXIS_RIGHTY -> ControllerAxisRightY
    Raw.SDL_GAMEPAD_AXIS_LEFT_TRIGGER -> ControllerAxisTriggerLeft
    Raw.SDL_GAMEPAD_AXIS_RIGHT_TRIGGER -> ControllerAxisTriggerRight
    Raw.SDL_GAMEPAD_AXIS_COUNT -> ControllerAxisMax
    _ -> ControllerAxisInvalid

-- | Identifies whether the game controller was added, removed, or remapped.
data ControllerDeviceConnection
  = ControllerDeviceAdded
  | ControllerDeviceRemoved
  | ControllerDeviceRemapped
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

instance FromNumber ControllerDeviceConnection Word32 where
  fromNumber n = case n of
    Raw.SDL_EVENT_GAMEPAD_ADDED -> ControllerDeviceAdded
    Raw.SDL_EVENT_GAMEPAD_REMOVED -> ControllerDeviceRemoved
    _ -> ControllerDeviceRemapped
