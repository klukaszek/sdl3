{-# LANGUAGE CPP #-}
{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}

module SDL.Video.OpenGL
  ( -- * Creating and Configuring OpenGL Contexts
    defaultOpenGL
  , OpenGLConfig(..)
  , GLContext
  , glCreateContext
  , Profile(..)
  , Mode(..)
  , glMakeCurrent
    
  -- * Function Loading
  , Raw.glGetProcAddress
  ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Data (Data)
import Data.StateVar
import Data.Typeable
import Foreign hiding (void, throwIf_, throwIfNull, throwIfNeg, throwIfNeg_)
import Foreign.C.Types
import GHC.Generics (Generic)
import SDL.Vect
import SDL.Internal.Exception
import SDL.Internal.Numbered
import SDL.Internal.Types
import qualified SDL.Raw as Raw

#if !MIN_VERSION_base(4,8,0)
import Control.Applicative
#endif

-- | A set of default options for 'OpenGLConfig'
--
-- @
-- 'defaultOpenGL' = 'OpenGLConfig'
--   { 'glColorPrecision' = V4 8 8 8 0
--   , 'glDepthPrecision' = 24
--   , 'glStencilPrecision' = 8
--   , 'glMultisampleSamples' = 1
--   , 'glProfile' = 'Compatibility' 'Normal' 2 1
--   }
-- @
defaultOpenGL :: OpenGLConfig
defaultOpenGL = OpenGLConfig
  { glColorPrecision = V4 8 8 8 0
  , glDepthPrecision = 24
  , glStencilPrecision = 8
  , glMultisampleSamples = 1
  , glProfile = Compatibility Normal 2 1
  }

-- | Configuration used when creating an OpenGL rendering context.
data OpenGLConfig = OpenGLConfig
  { glColorPrecision     :: V4 CInt -- ^ Defaults to 'V4' @8 8 8 0@.
  , glDepthPrecision     :: CInt    -- ^ Defaults to @24@.
  , glStencilPrecision   :: CInt    -- ^ Defaults to @8@.
  , glMultisampleSamples :: CInt    -- ^ Defaults to @1@.
  , glProfile            :: Profile -- ^ Defaults to 'Compatibility' 'Normal' @2 1@.
  } deriving (Eq, Generic, Ord, Read, Show, Typeable)

-- | The profile a driver should use when creating an OpenGL context.
data Profile
  = Core Mode CInt CInt
    -- ^ Use the OpenGL core profile, with a given major and minor version
  | Compatibility Mode CInt CInt
    -- ^ Use the compatibilty profile with a given major and minor version. The compatibility profile allows you to use deprecated functions such as immediate mode
  | ES Mode CInt CInt
    -- ^ Use an OpenGL profile for embedded systems
  deriving (Eq, Generic, Ord, Read, Show, Typeable)

-- | The mode a driver should use when creating an OpenGL context.
data Mode
  = Normal
    -- ^ A normal profile with no special debugging support
  | Debug
    -- ^ Use a debug context, allowing the usage of extensions such as @GL_ARB_debug_output@
  deriving (Bounded, Data, Enum, Eq, Generic, Ord, Read, Show, Typeable)

-- | A created OpenGL context.
newtype GLContext = GLContext Raw.GLContext
  deriving (Eq, Typeable)

-- | Create a new OpenGL context and makes it the current context for the
-- window.
--
-- Throws 'SDLException' if the window wasn't configured with OpenGL
-- support, or if context creation fails.
--
-- See @<https://wiki.libsdl.org/SDL_GL_CreateContext SDL_GL_CreateContext>@ for C documentation.
glCreateContext :: (Functor m, MonadIO m) => Window -> m GLContext
glCreateContext (Window w) =
  GLContext <$> throwIfNull "SDL.Video.glCreateContext" "SDL_GL_CreateContext"
    (Raw.glCreateContext w)

-- | Set up an OpenGL context for rendering into an OpenGL window.
--
-- Throws 'SDLException' on failure.
--
-- See @<https://wiki.libsdl.org/SDL_GL_MakeCurrent SDL_GL_MakeCurrent>@ for C documentation.
glMakeCurrent :: (Functor m, MonadIO m) => Window -> GLContext -> m ()
glMakeCurrent (Window w) (GLContext ctx) =
  throwIf_ not "SDL.Video.OpenGL.glMakeCurrent" "SDL_GL_MakeCurrent" $
    Raw.glMakeCurrent w ctx
