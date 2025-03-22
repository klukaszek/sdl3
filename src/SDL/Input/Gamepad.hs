{-# LANGUAGE CPP #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeSynonymInstances #-}

module SDL.Input.Gamepad
  ( GamepadDevice (..)
  , availableGamepads

  , openGamepad
  , closeGamepad
  , controllerAttached

  , getGamepadID

  , controllerMapping
  , addGamepadMapping
  , addGamepadMappingsFromFile

  , GamepadButton -- Re-exported from Enum.hsc
  , GamepadButtonState (..)
  , controllerButton

  , GamepadAxis -- Re-exported from Enum.hsc
  , controllerAxis
  
  , GamepadDeviceConnection (..)
  ) where

import Control.Monad (filterM, when)
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
import Foreign.Marshal.Array
import Foreign.Ptr
import Foreign.Storable
import GHC.Generics (Generic)
import GHC.Int (Int32)
import SDL.Internal.Exception
import SDL.Internal.Numbered
import SDL.Internal.Types (Gamepad(..))
import SDL.Raw.Enum
import SDL.Raw.Types (JoystickID)
import SDL.Vect
import qualified SDL.Raw.Basic as Basic
import qualified SDL.Raw.Gamepad as Raw
import qualified Data.ByteString as BS
import qualified Data.ByteString.Internal as BSI
import qualified Data.Text.Encoding as Text
import qualified Data.Vector as V

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative
#endif

data GamepadDevice = GamepadDevice
  { gamepadDeviceName :: Text
  , gamepadDeviceId :: JoystickID
  }
  deriving (Eq, Generic, Read, Ord, Show, Typeable)

availableGamepads :: MonadIO m => m (V.Vector GamepadDevice)
availableGamepads = liftIO $ do
  countPtr <- malloc
  ids <- throwIfNull "SDL.Input.Gamepad.availableGamepads" "SDL_GetGamepads" $
         Raw.getGamepads countPtr
  count <- peek countPtr
  Basic.free (castPtr countPtr)
  indices <- peekArray (fromIntegral count) ids
  Basic.free (castPtr ids)
  fmap V.fromList $ for indices $ \i -> do
    cstr <- throwIfNull "SDL.Input.Gamepad.availableGamepads" "SDL_GetGamepadNameForID" $
            Raw.getGamepadNameForID i
    name <- Text.decodeUtf8 <$> BS.packCString cstr
    return (GamepadDevice name i)

openGamepad :: (Functor m, MonadIO m) => GamepadDevice -> m Gamepad
openGamepad (GamepadDevice _ x) = liftIO $ do
  ptr <- throwIfNull "SDL.Input.Gamepad.openGamepad" "SDL_OpenGamepad" $
         Raw.openGamepad x
  Gamepad <$> newForeignPtr Raw.finalizeGamepad (castPtr ptr)

closeGamepad :: MonadIO m => Gamepad -> m ()
closeGamepad (Gamepad g) = liftIO $ do
  withForeignPtr g $ \ptr -> when (ptr /= nullPtr) $ Raw.closeGamepad ptr

controllerAttached :: MonadIO m => Gamepad -> m CBool
controllerAttached (Gamepad c) = liftIO $ withForeignPtr c $ \ptr -> Raw.gamepadConnected ptr

getGamepadID :: MonadIO m => Gamepad -> m JoystickID
getGamepadID (Gamepad c) = liftIO $
  throwIfNeg "SDL.Input.Gamepad.getGamepadID" "SDL_GetGamepadID" $
    withForeignPtr c $ \ptr -> Raw.getGamepadID ptr

controllerMapping :: MonadIO m => Gamepad -> m Text
controllerMapping (Gamepad c) = liftIO $ do
  mapping <- throwIfNull "SDL.Input.Gamepad.controllerMapping" "SDL_GetGamepadMapping" $
             withForeignPtr c $ \ptr -> Raw.getGamepadMapping ptr
  Text.decodeUtf8 <$> BS.packCString mapping

addGamepadMapping :: MonadIO m => BS.ByteString -> m Int
addGamepadMapping mapping =
  liftIO $
    throwIfNeg "SDL.Input.Gamepad.addGamepadMapping" "SDL_AddGamepadMapping" $
      let (mappingForeign, _, _) = BSI.toForeignPtr mapping
       in withForeignPtr mappingForeign $ \mappingPtr ->
            fromIntegral <$> Raw.addGamepadMapping (castPtr mappingPtr)

addGamepadMappingsFromFile :: MonadIO m => FilePath -> m Int
addGamepadMappingsFromFile mappingFile =
  liftIO $
    throwIfNeg "SDL.Input.Gamepad.addGamepadMappingsFromFile" "SDL_AddGamepadMappingsFromFile" $
      fromIntegral <$> withCString mappingFile Raw.addGamepadMappingsFromFile

controllerAxis :: MonadIO m => Gamepad -> GamepadAxis -> m Int16
controllerAxis (Gamepad c) axis = liftIO $
  withForeignPtr c $ \ptr -> Raw.getGamepadAxis ptr axis

controllerButton :: MonadIO m => Gamepad -> GamepadButton -> m GamepadButtonState
controllerButton (Gamepad c) button = liftIO $
  fromNumber . fromIntegral <$> withForeignPtr c (\ptr -> Raw.getGamepadButton ptr button)

data GamepadButtonState
  = GamepadButtonPressed
  | GamepadButtonReleased
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

instance FromNumber GamepadButtonState Word8 where
  fromNumber n = case n of
    1 -> GamepadButtonPressed
    0 -> GamepadButtonReleased
    _ -> GamepadButtonReleased -- Default to Released for invalid values

instance ToNumber GamepadAxis Int32 where
  toNumber (GamepadAxis a) = a

instance ToNumber GamepadButton Int32 where
  toNumber (GamepadButton b) = b

data GamepadDeviceConnection
  = GamepadDeviceAdded
  | GamepadDeviceRemoved
  | GamepadDeviceRemapped
  deriving (Data, Eq, Generic, Ord, Read, Show, Typeable)

instance FromNumber GamepadDeviceConnection Word32 where
  fromNumber n = case n of
    SDL_EVENT_GAMEPAD_ADDED -> GamepadDeviceAdded
    SDL_EVENT_GAMEPAD_REMOVED -> GamepadDeviceRemoved
    SDL_EVENT_GAMEPAD_REMAPPED -> GamepadDeviceRemapped
    _ -> GamepadDeviceRemapped -- Default to Remapped for unknown values
