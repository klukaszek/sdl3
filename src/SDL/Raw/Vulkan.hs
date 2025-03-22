{-# LANGUAGE CPP #-}

module SDL.Raw.Vulkan
  (-- * Vulkan support functions
    vkLoadLibrary,
    vkGetVkGetInstanceProcAddr,
    vkUnloadLibrary,
    vkGetInstanceExtensions,
    vkCreateSurface,
    vkGetDrawableSize,
  )
where

import Control.Monad.IO.Class
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import SDL.Raw.Enum
import SDL.Raw.Types

-- Vulkan support functions
foreign import ccall "SDL3/SDL_vulkan.h SDL_Vulkan_LoadLibrary" vkLoadLibraryFFI :: CString -> IO Bool
foreign import ccall "SDL3/SDL_vulkan.h SDL_Vulkan_GetVkGetInstanceProcAddr" vkGetVkGetInstanceProcAddrFFI :: IO (FunPtr VkGetInstanceProcAddrFunc)
foreign import ccall "SDL3/SDL_vulkan.h SDL_Vulkan_UnloadLibrary" vkUnloadLibraryFFI :: IO ()
foreign import ccall "SDL3/SDL_vulkan.h SDL_Vulkan_GetInstanceExtensions" vkGetInstanceExtensionsFFI :: Window -> Ptr CUInt -> Ptr CString -> IO Bool
foreign import ccall "SDL3/SDL_vulkan.h SDL_Vulkan_CreateSurface" vkCreateSurfaceFFI :: Window -> VkInstance -> Ptr VkSurfaceKHR -> IO Bool
foreign import ccall "SDL3/SDL_vulkan.h SDL_Vulkan_GetDrawableSize" vkGetDrawableSizeFFI :: Window -> Ptr CInt -> Ptr CInt -> IO ()

-- Function wrappers
vkLoadLibrary :: MonadIO m => CString -> m Bool
vkLoadLibrary path = liftIO $ vkLoadLibraryFFI path
{-# INLINE vkLoadLibrary #-}

vkGetVkGetInstanceProcAddr :: MonadIO m => m (FunPtr VkGetInstanceProcAddrFunc)
vkGetVkGetInstanceProcAddr = liftIO vkGetVkGetInstanceProcAddrFFI
{-# INLINE vkGetVkGetInstanceProcAddr #-}

vkUnloadLibrary :: MonadIO m => m ()
vkUnloadLibrary = liftIO vkUnloadLibraryFFI
{-# INLINE vkUnloadLibrary #-}

vkGetInstanceExtensions :: MonadIO m => Window -> Ptr CUInt -> Ptr CString -> m Bool
vkGetInstanceExtensions window count names = liftIO $ vkGetInstanceExtensionsFFI window count names
{-# INLINE vkGetInstanceExtensions #-}

vkCreateSurface :: MonadIO m => Window -> VkInstance -> Ptr VkSurfaceKHR -> m Bool
vkCreateSurface window instance_ surface = liftIO $ vkCreateSurfaceFFI window instance_ surface
{-# INLINE vkCreateSurface #-}

vkGetDrawableSize :: MonadIO m => Window -> Ptr CInt -> Ptr CInt -> m ()
vkGetDrawableSize window w h = liftIO $ vkGetDrawableSizeFFI window w h
{-# INLINE vkGetDrawableSize #-}
