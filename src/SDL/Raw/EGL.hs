{-# LANGUAGE CPP #-}

module SDL.Raw.EGL
  ( -- * EGL support functions
    eglGetProcAddress,
    eglSetAttributeCallbacks,
    eglGetCurrentDisplay,
    eglGetCurrentConfig,
  )
where

import Control.Monad.IO.Class
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import SDL.Raw.Enum
import SDL.Raw.Types

-- EGL support functions
foreign import ccall "SDL3/SDL.h SDL_EGL_GetProcAddress" eglGetProcAddressFFI :: CString -> IO (Ptr ())
foreign import ccall "SDL3/SDL.h SDL_EGL_SetAttributeCallbacks" eglSetAttributeCallbacksFFI :: FunPtr EGLAttribArrayCallback -> FunPtr EGLIntArrayCallback -> FunPtr EGLIntArrayCallback -> Ptr () -> IO ()
foreign import ccall "SDL3/SDL.h SDL_EGL_GetCurrentDisplay" eglGetCurrentDisplayFFI :: IO EGLDisplay
foreign import ccall "SDL3/SDL.h SDL_EGL_GetCurrentConfig" eglGetCurrentConfigFFI :: IO EGLConfig

-- Function wrappers
eglGetProcAddress :: MonadIO m => CString -> m (Ptr ())
eglGetProcAddress proc = liftIO $ eglGetProcAddressFFI proc
{-# INLINE eglGetProcAddress #-}

eglSetAttributeCallbacks :: MonadIO m => FunPtr EGLAttribArrayCallback -> FunPtr EGLIntArrayCallback -> FunPtr EGLIntArrayCallback -> Ptr () -> m ()
eglSetAttributeCallbacks platformAttribCallback surfaceAttribCallback contextAttribCallback userdata = 
    liftIO $ eglSetAttributeCallbacksFFI platformAttribCallback surfaceAttribCallback contextAttribCallback userdata
{-# INLINE eglSetAttributeCallbacks #-}

eglGetCurrentDisplay :: MonadIO m => m EGLDisplay
eglGetCurrentDisplay = liftIO eglGetCurrentDisplayFFI
{-# INLINE eglGetCurrentDisplay #-}

eglGetCurrentConfig :: MonadIO m => m EGLConfig
eglGetCurrentConfig = liftIO eglGetCurrentConfigFFI
{-# INLINE eglGetCurrentConfig #-}
