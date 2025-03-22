{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE StandaloneDeriving #-}

module SDL.Internal.Types
  ( Joystick(..)
  , Gamepad(..)
  , Window(..)
  , Renderer(..)
  ) where

import Data.Data (Data)
import Data.Typeable
import Foreign.ForeignPtr (ForeignPtr)
import GHC.Generics (Generic)

import qualified SDL.Raw.Types as Raw

newtype Joystick = Joystick { joystickPtr :: ForeignPtr () }
  deriving (Data, Eq, Generic, Ord, Show, Typeable)

newtype Gamepad = Gamepad
  { gamepadPtr :: ForeignPtr () }
  deriving (Data, Eq, Generic, Ord, Show, Typeable)

newtype Window = Window Raw.Window
  deriving (Data, Eq, Generic, Ord, Show, Typeable)

newtype Renderer = Renderer Raw.Renderer
  deriving (Data, Eq, Generic, Ord, Show, Typeable)
