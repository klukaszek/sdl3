{-# LANGUAGE CPP #-}

module SDL.Raw.OpenGL
  (
    -- * GL Functions
    glBindTexture,
    glCreateContext,
    glDeleteContext,
    glExtensionSupported,
    glGetAttribute,
    glGetCurrentContext,
    glGetCurrentWindow,
    glGetProcAddress,
    glGetSwapInterval,
    glLoadLibrary,
    glMakeCurrent,
    glResetAttributes,
    glSetAttribute,
    glSetSwapInterval,
    glSwapWindow,
    glUnloadLibrary,
  )
where

import Control.Monad.IO.Class
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import SDL.Raw.Enum
import SDL.Raw.Types

-- * GL Functions
foreign import ccall "SDL3/SDL.h SDL_GL_BindTexture" glBindTextureFFI :: Texture -> Ptr CFloat -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_CreateContext" glCreateContextFFI :: Window -> IO GLContext
foreign import ccall "SDL3/SDL.h SDL_GL_DestroyContext" glDeleteContextFFI :: GLContext -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_ExtensionSupported" glExtensionSupportedFFI :: CString -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_GetAttribute" glGetAttributeFFI :: GLAttr -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_GetCurrentContext" glGetCurrentContextFFI :: IO GLContext
foreign import ccall "SDL3/SDL.h SDL_GL_GetCurrentWindow" glGetCurrentWindowFFI :: IO Window
foreign import ccall "SDL3/SDL.h SDL_GL_GetProcAddress" glGetProcAddressFFI :: CString -> IO (Ptr ())
foreign import ccall "SDL3/SDL.h SDL_GL_GetSwapInterval" glGetSwapIntervalFFI :: Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_LoadLibrary" glLoadLibraryFFI :: CString -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_MakeCurrent" glMakeCurrentFFI :: Window -> GLContext -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_ResetAttributes" glResetAttributesFFI :: IO ()
foreign import ccall "SDL3/SDL.h SDL_GL_SetAttribute" glSetAttributeFFI :: GLAttr -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_SetSwapInterval" glSetSwapIntervalFFI :: CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_SwapWindow" glSwapWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GL_UnloadLibrary" glUnloadLibraryFFI :: IO ()

-- Function wrappers
glBindTexture :: MonadIO m => Texture -> Ptr CFloat -> Ptr CFloat -> m Bool
glBindTexture texture texw texh = liftIO $ glBindTextureFFI texture texw texh
{-# INLINE glBindTexture #-}

glCreateContext :: MonadIO m => Window -> m GLContext
glCreateContext window = liftIO $ glCreateContextFFI window
{-# INLINE glCreateContext #-}

glDeleteContext :: MonadIO m => GLContext -> m Bool
glDeleteContext context = liftIO $ glDeleteContextFFI context
{-# INLINE glDeleteContext #-}

glExtensionSupported :: MonadIO m => CString -> m Bool
glExtensionSupported extension = liftIO $ glExtensionSupportedFFI extension
{-# INLINE glExtensionSupported #-}

glGetAttribute :: MonadIO m => GLAttr -> Ptr CInt -> m Bool
glGetAttribute attr value = liftIO $ glGetAttributeFFI attr value
{-# INLINE glGetAttribute #-}

glGetCurrentContext :: MonadIO m => m GLContext
glGetCurrentContext = liftIO glGetCurrentContextFFI
{-# INLINE glGetCurrentContext #-}

glGetCurrentWindow :: MonadIO m => m Window
glGetCurrentWindow = liftIO glGetCurrentWindowFFI
{-# INLINE glGetCurrentWindow #-}

glGetProcAddress :: MonadIO m => CString -> m (Ptr ())
glGetProcAddress proc = liftIO $ glGetProcAddressFFI proc
{-# INLINE glGetProcAddress #-}

glGetSwapInterval :: MonadIO m => Ptr CInt -> m Bool
glGetSwapInterval interval = liftIO $ glGetSwapIntervalFFI interval
{-# INLINE glGetSwapInterval #-}

glLoadLibrary :: MonadIO m => CString -> m Bool
glLoadLibrary path = liftIO $ glLoadLibraryFFI path
{-# INLINE glLoadLibrary #-}

glMakeCurrent :: MonadIO m => Window -> GLContext -> m Bool
glMakeCurrent window context = liftIO $ glMakeCurrentFFI window context
{-# INLINE glMakeCurrent #-}

glResetAttributes :: MonadIO m => m ()
glResetAttributes = liftIO glResetAttributesFFI
{-# INLINE glResetAttributes #-}

glSetAttribute :: MonadIO m => GLAttr -> CInt -> m Bool
glSetAttribute attr value = liftIO $ glSetAttributeFFI attr value
{-# INLINE glSetAttribute #-}

glSetSwapInterval :: MonadIO m => CInt -> m Bool
glSetSwapInterval interval = liftIO $ glSetSwapIntervalFFI interval
{-# INLINE glSetSwapInterval #-}

glSwapWindow :: MonadIO m => Window -> m Bool
glSwapWindow window = liftIO $ glSwapWindowFFI window
{-# INLINE glSwapWindow #-}

glUnloadLibrary :: MonadIO m => m ()
glUnloadLibrary = liftIO glUnloadLibraryFFI
{-# INLINE glUnloadLibrary #-}
