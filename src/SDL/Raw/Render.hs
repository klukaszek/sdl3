{-# LANGUAGE CPP #-}

module SDL.Raw.Render (
  -- * Renderer Management
  getNumRenderDrivers,
  getRenderDriver,
  createWindowAndRenderer,
  createRenderer,
  createRendererWithProperties,
  createSoftwareRenderer,
  getRenderer,
  getRenderWindow,
  getRendererName,
  getRendererProperties,
  getRenderOutputSize,
  getCurrentRenderOutputSize,
  destroyRenderer,
  flushRenderer,

  -- * Texture Management
  createTexture,
  createTextureFromSurface,
  createTextureWithProperties,
  getRendererFromTexture,
  getTextureProperties,
  getTextureSize,
  setTextureColorMod,
  setTextureColorModFloat,
  getTextureColorMod,
  getTextureColorModFloat,
  setTextureAlphaMod,
  setTextureAlphaModFloat,
  getTextureAlphaMod,
  getTextureAlphaModFloat,
  setTextureBlendMode,
  getTextureBlendMode,
  setTextureScaleMode,
  getTextureScaleMode,
  updateTexture,
  updateYUVTexture,
  updateNVTexture,
  lockTexture,
  lockTextureToSurface,
  unlockTexture,
  destroyTexture,

  -- * Rendering Operations
  setRenderTarget,
  getRenderTarget,
  setRenderLogicalPresentation,
  getRenderLogicalPresentation,
  getRenderLogicalPresentationRect,
  renderCoordinatesToWindow,
  renderCoordinatesFromWindow,
  convertEventToRenderCoordinates,
  setRenderViewport,
  getRenderViewport,
  renderViewportSet,
  getRenderSafeArea,
  setRenderClipRect,
  getRenderClipRect,
  renderClipEnabled,
  setRenderScale,
  getRenderScale,
  setRenderDrawColor,
  setRenderDrawColorFloat,
  getRenderDrawColor,
  getRenderDrawColorFloat,
  setRenderColorScale,
  getRenderColorScale,
  setRenderDrawBlendMode,
  getRenderDrawBlendMode,
  renderClear,
  renderPoint,
  renderPoints,
  renderLine,
  renderLines,
  renderRect,
  renderRects,
  renderFillRect,
  renderFillRects,
  renderTexture,
  renderTextureRotated,
  renderTextureAffine,
  renderTextureTiled,
  renderTexture9Grid,
  renderTexture9GridTiled,
  renderGeometry,
  renderGeometryRaw,
  renderReadPixels,
  renderPresent,

  -- * Platform-Specific Functions
  getRenderMetalLayer,
  getRenderMetalCommandEncoder,
  addVulkanRenderSemaphores,

  -- * VSync Control
  setRenderVSync,
  getRenderVSync,

  -- * Debug Text Rendering
  renderDebugText,
  renderDebugTextFormat,

  -- * Default Texture Scale Mode
  setDefaultTextureScaleMode,
  getDefaultTextureScaleMode,

  -- * GPU Render State
  createGPURenderState,
  setGPURenderStateFragmentUniforms,
  setRenderGPUState,
  destroyGPURenderState
) where

import Control.Monad.IO.Class
import Data.Word
import Data.Int
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import SDL.Raw.Types
import SDL.Raw.Enum

-- Renderer Management
foreign import ccall "SDL3/SDL_render.h SDL_GetNumRenderDrivers" getNumRenderDriversFFI :: IO CInt
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderDriver" getRenderDriverFFI :: CInt -> IO CString
foreign import ccall "SDL3/SDL_render.h SDL_CreateWindowAndRenderer" createWindowAndRendererFFI :: CString -> CInt -> CInt -> Word32 -> Ptr Window -> Ptr Renderer -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_CreateRenderer" createRendererFFI :: Window -> CString -> IO Renderer
foreign import ccall "SDL3/SDL_render.h SDL_CreateRendererWithProperties" createRendererWithPropertiesFFI :: PropertiesID -> IO Renderer
foreign import ccall "SDL3/SDL_render.h SDL_CreateSoftwareRenderer" createSoftwareRendererFFI :: Ptr Surface -> IO Renderer
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderer" getRendererFFI :: Window -> IO Renderer
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderWindow" getRenderWindowFFI :: Renderer -> IO Window
foreign import ccall "SDL3/SDL_render.h SDL_GetRendererName" getRendererNameFFI :: Renderer -> IO CString
foreign import ccall "SDL3/SDL_render.h SDL_GetRendererProperties" getRendererPropertiesFFI :: Renderer -> IO PropertiesID
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderOutputSize" getRenderOutputSizeFFI :: Renderer -> Ptr CInt -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetCurrentRenderOutputSize" getCurrentRenderOutputSizeFFI :: Renderer -> Ptr CInt -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_DestroyRenderer" destroyRendererFFI :: Renderer -> IO ()
foreign import ccall "SDL3/SDL_render.h SDL_FlushRenderer" flushRendererFFI :: Renderer -> IO Bool

-- Texture Management
foreign import ccall "SDL3/SDL_render.h SDL_CreateTexture" createTextureFFI :: Renderer -> PixelFormat -> TextureAccess -> CInt -> CInt -> IO Texture
foreign import ccall "SDL3/SDL_render.h SDL_CreateTextureFromSurface" createTextureFromSurfaceFFI :: Renderer -> Ptr Surface -> IO Texture
foreign import ccall "SDL3/SDL_render.h SDL_CreateTextureWithProperties" createTextureWithPropertiesFFI :: Renderer -> PropertiesID -> IO Texture
foreign import ccall "SDL3/SDL_render.h SDL_GetRendererFromTexture" getRendererFromTextureFFI :: Texture -> IO Renderer
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureProperties" getTexturePropertiesFFI :: Texture -> IO PropertiesID
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureSize" getTextureSizeFFI :: Texture -> Ptr CFloat -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetTextureColorMod" setTextureColorModFFI :: Texture -> Word8 -> Word8 -> Word8 -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetTextureColorModFloat" setTextureColorModFloatFFI :: Texture -> CFloat -> CFloat -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureColorMod" getTextureColorModFFI :: Texture -> Ptr Word8 -> Ptr Word8 -> Ptr Word8 -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureColorModFloat" getTextureColorModFloatFFI :: Texture -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetTextureAlphaMod" setTextureAlphaModFFI :: Texture -> Word8 -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetTextureAlphaModFloat" setTextureAlphaModFloatFFI :: Texture -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureAlphaMod" getTextureAlphaModFFI :: Texture -> Ptr Word8 -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureAlphaModFloat" getTextureAlphaModFloatFFI :: Texture -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetTextureBlendMode" setTextureBlendModeFFI :: Texture -> BlendMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureBlendMode" getTextureBlendModeFFI :: Texture -> Ptr BlendMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetTextureScaleMode" setTextureScaleModeFFI :: Texture -> ScaleMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetTextureScaleMode" getTextureScaleModeFFI :: Texture -> Ptr ScaleMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_UpdateTexture" updateTextureFFI :: Texture -> Ptr Rect -> Ptr () -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_UpdateYUVTexture" updateYUVTextureFFI :: Texture -> Ptr Rect -> Ptr Word8 -> CInt -> Ptr Word8 -> CInt -> Ptr Word8 -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_UpdateNVTexture" updateNVTextureFFI :: Texture -> Ptr Rect -> Ptr Word8 -> CInt -> Ptr Word8 -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_LockTexture" lockTextureFFI :: Texture -> Ptr Rect -> Ptr (Ptr ()) -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_LockTextureToSurface" lockTextureToSurfaceFFI :: Texture -> Ptr Rect -> Ptr Surface -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_UnlockTexture" unlockTextureFFI :: Texture -> IO ()
foreign import ccall "SDL3/SDL_render.h SDL_DestroyTexture" destroyTextureFFI :: Texture -> IO ()

-- Rendering Operations
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderTarget" setRenderTargetFFI :: Renderer -> Texture -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderTarget" getRenderTargetFFI :: Renderer -> IO Texture
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderLogicalPresentation" setRenderLogicalPresentationFFI :: Renderer -> CInt -> CInt -> RendererLogicalPresentation -> ScaleMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderLogicalPresentation" getRenderLogicalPresentationFFI :: Renderer -> Ptr CInt -> Ptr CInt -> Ptr RendererLogicalPresentation -> Ptr ScaleMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderLogicalPresentationRect" getRenderLogicalPresentationRectFFI :: Renderer -> Ptr FRect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderCoordinatesToWindow" renderCoordinatesToWindowFFI :: Renderer -> CFloat -> CFloat -> Ptr CFloat -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderCoordinatesFromWindow" renderCoordinatesFromWindowFFI :: Renderer -> CFloat -> CFloat -> Ptr CFloat -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_ConvertEventToRenderCoordinates" convertEventToRenderCoordinatesFFI :: Renderer -> Ptr Event -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderViewport" setRenderViewportFFI :: Renderer -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderViewport" getRenderViewportFFI :: Renderer -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderViewportSet" renderViewportSetFFI :: Renderer -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderSafeArea" getRenderSafeAreaFFI :: Renderer -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderClipRect" setRenderClipRectFFI :: Renderer -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderClipRect" getRenderClipRectFFI :: Renderer -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderClipEnabled" renderClipEnabledFFI :: Renderer -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderScale" setRenderScaleFFI :: Renderer -> CFloat -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderScale" getRenderScaleFFI :: Renderer -> Ptr CFloat -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderDrawColor" setRenderDrawColorFFI :: Renderer -> Word8 -> Word8 -> Word8 -> Word8 -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderDrawColorFloat" setRenderDrawColorFloatFFI :: Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderDrawColor" getRenderDrawColorFFI :: Renderer -> Ptr Word8 -> Ptr Word8 -> Ptr Word8 -> Ptr Word8 -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderDrawColorFloat" getRenderDrawColorFloatFFI :: Renderer -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderColorScale" setRenderColorScaleFFI :: Renderer -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderColorScale" getRenderColorScaleFFI :: Renderer -> Ptr CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderDrawBlendMode" setRenderDrawBlendModeFFI :: Renderer -> BlendMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderDrawBlendMode" getRenderDrawBlendModeFFI :: Renderer -> Ptr BlendMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderClear" renderClearFFI :: Renderer -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderPoint" renderPointFFI :: Renderer -> CFloat -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderPoints" renderPointsFFI :: Renderer -> Ptr FPoint -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderLine" renderLineFFI :: Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderLines" renderLinesFFI :: Renderer -> Ptr FPoint -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderRect" renderRectFFI :: Renderer -> Ptr FRect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderRects" renderRectsFFI :: Renderer -> Ptr FRect -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderFillRect" renderFillRectFFI :: Renderer -> Ptr FRect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderFillRects" renderFillRectsFFI :: Renderer -> Ptr FRect -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderTexture" renderTextureFFI :: Renderer -> Texture -> Ptr FRect -> Ptr FRect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderTextureRotated" renderTextureRotatedFFI :: Renderer -> Texture -> Ptr FRect -> Ptr FRect -> CDouble -> Ptr FPoint -> FlipMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderTextureAffine" renderTextureAffineFFI :: Renderer -> Texture -> Ptr FRect -> Ptr FPoint -> Ptr FPoint -> Ptr FPoint -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderTextureTiled" renderTextureTiledFFI :: Renderer -> Texture -> Ptr FRect -> CFloat -> Ptr FRect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderTexture9Grid" renderTexture9GridFFI :: Renderer -> Texture -> Ptr FRect -> CFloat -> CFloat -> CFloat -> CFloat -> CFloat -> Ptr FRect -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderTexture9GridTiled" renderTexture9GridTiledFFI :: Renderer -> Texture -> Ptr FRect -> CFloat -> CFloat -> CFloat -> CFloat -> CFloat -> Ptr FRect -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderGeometry" renderGeometryFFI :: Renderer -> Texture -> Ptr Vertex -> CInt -> Ptr CInt -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderGeometryRaw" renderGeometryRawFFI :: Renderer -> Texture -> Ptr CFloat -> CInt -> Ptr FColor -> CInt -> Ptr CFloat -> CInt -> CInt -> Ptr () -> CInt -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderReadPixels" renderReadPixelsFFI :: Renderer -> Ptr Rect -> IO (Ptr Surface)
foreign import ccall "SDL3/SDL_render.h SDL_RenderPresent" renderPresentFFI :: Renderer -> IO Bool

-- Platform-Specific Functions
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderMetalLayer" getRenderMetalLayerFFI :: Renderer -> IO (Ptr ())
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderMetalCommandEncoder" getRenderMetalCommandEncoderFFI :: Renderer -> IO (Ptr ())
foreign import ccall "SDL3/SDL_render.h SDL_AddVulkanRenderSemaphores" addVulkanRenderSemaphoresFFI :: Renderer -> Word32 -> Int64 -> Int64 -> IO Bool

-- VSync Control
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderVSync" setRenderVSyncFFI :: Renderer -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetRenderVSync" getRenderVSyncFFI :: Renderer -> Ptr CInt -> IO Bool

-- Debug Text Rendering
foreign import ccall "SDL3/SDL_render.h SDL_RenderDebugText" renderDebugTextFFI :: Renderer -> CFloat -> CFloat -> CString -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_RenderDebugTextFormat" renderDebugTextFormatFFI :: Renderer -> CFloat -> CFloat -> CString -> IO Bool  -- Note: Variadic function, simplified here

-- Default Texture Scale Mode
foreign import ccall "SDL3/SDL_render.h SDL_SetDefaultTextureScaleMode" setDefaultTextureScaleModeFFI :: Renderer -> ScaleMode -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_GetDefaultTextureScaleMode" getDefaultTextureScaleModeFFI :: Renderer -> Ptr ScaleMode -> IO Bool

-- GPU Render State
foreign import ccall "SDL3/SDL_render.h SDL_CreateGPURenderState" createGPURenderStateFFI :: Renderer -> Ptr GPURenderStateDesc -> IO GPURenderState
foreign import ccall "SDL3/SDL_render.h SDL_SetGPURenderStateFragmentUniforms" setGPURenderStateFragmentUniformsFFI :: GPURenderState -> Word32 -> Ptr () -> Word32 -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_SetRenderGPUState" setRenderGPUStateFFI :: Renderer -> GPURenderState -> IO Bool
foreign import ccall "SDL3/SDL_render.h SDL_DestroyGPURenderState" destroyGPURenderStateFFI :: GPURenderState -> IO ()

-- Haskell Wrappers
getNumRenderDrivers :: MonadIO m => m CInt
getNumRenderDrivers = liftIO getNumRenderDriversFFI
{-# INLINE getNumRenderDrivers #-}

getRenderDriver :: MonadIO m => CInt -> m CString
getRenderDriver index = liftIO $ getRenderDriverFFI index
{-# INLINE getRenderDriver #-}

createWindowAndRenderer :: MonadIO m => CString -> CInt -> CInt -> Word32 -> Ptr Window -> Ptr Renderer -> m Bool
createWindowAndRenderer title w h flags win rend = liftIO $ createWindowAndRendererFFI title w h flags win rend
{-# INLINE createWindowAndRenderer #-}

createRenderer :: MonadIO m => Window -> CString -> m Renderer
createRenderer win name = liftIO $ createRendererFFI win name
{-# INLINE createRenderer #-}

createRendererWithProperties :: MonadIO m => PropertiesID -> m Renderer
createRendererWithProperties props = liftIO $ createRendererWithPropertiesFFI props
{-# INLINE createRendererWithProperties #-}

createSoftwareRenderer :: MonadIO m => Ptr Surface -> m Renderer
createSoftwareRenderer surf = liftIO $ createSoftwareRendererFFI surf
{-# INLINE createSoftwareRenderer #-}

getRenderer :: MonadIO m => Window -> m Renderer
getRenderer win = liftIO $ getRendererFFI win
{-# INLINE getRenderer #-}

getRenderWindow :: MonadIO m => Renderer -> m Window
getRenderWindow rend = liftIO $ getRenderWindowFFI rend
{-# INLINE getRenderWindow #-}

getRendererName :: MonadIO m => Renderer -> m CString
getRendererName rend = liftIO $ getRendererNameFFI rend
{-# INLINE getRendererName #-}

getRendererProperties :: MonadIO m => Renderer -> m PropertiesID
getRendererProperties rend = liftIO $ getRendererPropertiesFFI rend
{-# INLINE getRendererProperties #-}

getRenderOutputSize :: MonadIO m => Renderer -> Ptr CInt -> Ptr CInt -> m Bool
getRenderOutputSize rend w h = liftIO $ getRenderOutputSizeFFI rend w h
{-# INLINE getRenderOutputSize #-}

getCurrentRenderOutputSize :: MonadIO m => Renderer -> Ptr CInt -> Ptr CInt -> m Bool
getCurrentRenderOutputSize rend w h = liftIO $ getCurrentRenderOutputSizeFFI rend w h
{-# INLINE getCurrentRenderOutputSize #-}

destroyRenderer :: MonadIO m => Renderer -> m ()
destroyRenderer rend = liftIO $ destroyRendererFFI rend
{-# INLINE destroyRenderer #-}

flushRenderer :: MonadIO m => Renderer -> m Bool
flushRenderer rend = liftIO $ flushRendererFFI rend
{-# INLINE flushRenderer #-}

-- Texture Management Wrappers (example subset, add others similarly)
createTexture :: MonadIO m => Renderer -> PixelFormat -> TextureAccess -> CInt -> CInt -> m Texture
createTexture rend fmt acc w h = liftIO $ createTextureFFI rend fmt acc w h
{-# INLINE createTexture #-}

createTextureFromSurface :: MonadIO m => Renderer -> Ptr Surface -> m Texture
createTextureFromSurface rend surf = liftIO $ createTextureFromSurfaceFFI rend surf
{-# INLINE createTextureFromSurface #-}

createTextureWithProperties :: MonadIO m => Renderer -> PropertiesID -> m Texture
createTextureWithProperties rend props = liftIO $ createTextureWithPropertiesFFI rend props
{-# INLINE createTextureWithProperties #-}

getRendererFromTexture :: MonadIO m => Texture -> m Renderer
getRendererFromTexture tex = liftIO $ getRendererFromTextureFFI tex
{-# INLINE getRendererFromTexture #-}

getTextureProperties :: MonadIO m => Texture -> m PropertiesID
getTextureProperties tex = liftIO $ getTexturePropertiesFFI tex
{-# INLINE getTextureProperties #-}

getTextureSize :: MonadIO m => Texture -> Ptr CFloat -> Ptr CFloat -> m Bool
getTextureSize tex w h = liftIO $ getTextureSizeFFI tex w h
{-# INLINE getTextureSize #-}

setTextureColorMod :: MonadIO m => Texture -> Word8 -> Word8 -> Word8 -> m Bool
setTextureColorMod tex r g b = liftIO $ setTextureColorModFFI tex r g b
{-# INLINE setTextureColorMod #-}

setTextureColorModFloat :: MonadIO m => Texture -> CFloat -> CFloat -> CFloat -> m Bool
setTextureColorModFloat tex r g b = liftIO $ setTextureColorModFloatFFI tex r g b
{-# INLINE setTextureColorModFloat #-}

getTextureColorMod :: MonadIO m => Texture -> Ptr Word8 -> Ptr Word8 -> Ptr Word8 -> m Bool
getTextureColorMod tex r g b = liftIO $ getTextureColorModFFI tex r g b
{-# INLINE getTextureColorMod #-}

getTextureColorModFloat :: MonadIO m => Texture -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> m Bool
getTextureColorModFloat tex r g b = liftIO $ getTextureColorModFloatFFI tex r g b
{-# INLINE getTextureColorModFloat #-}

setTextureAlphaMod :: MonadIO m => Texture -> Word8 -> m Bool
setTextureAlphaMod tex a = liftIO $ setTextureAlphaModFFI tex a
{-# INLINE setTextureAlphaMod #-}

setTextureAlphaModFloat :: MonadIO m => Texture -> CFloat -> m Bool
setTextureAlphaModFloat tex a = liftIO $ setTextureAlphaModFloatFFI tex a
{-# INLINE setTextureAlphaModFloat #-}

getTextureAlphaMod :: MonadIO m => Texture -> Ptr Word8 -> m Bool
getTextureAlphaMod tex a = liftIO $ getTextureAlphaModFFI tex a
{-# INLINE getTextureAlphaMod #-}

getTextureAlphaModFloat :: MonadIO m => Texture -> Ptr CFloat -> m Bool
getTextureAlphaModFloat tex a = liftIO $ getTextureAlphaModFloatFFI tex a
{-# INLINE getTextureAlphaModFloat #-}

setTextureBlendMode :: MonadIO m => Texture -> BlendMode -> m Bool
setTextureBlendMode tex mode = liftIO $ setTextureBlendModeFFI tex mode
{-# INLINE setTextureBlendMode #-}

getTextureBlendMode :: MonadIO m => Texture -> Ptr BlendMode -> m Bool
getTextureBlendMode tex mode = liftIO $ getTextureBlendModeFFI tex mode
{-# INLINE getTextureBlendMode #-}

setTextureScaleMode :: MonadIO m => Texture -> ScaleMode -> m Bool
setTextureScaleMode tex mode = liftIO $ setTextureScaleModeFFI tex mode
{-# INLINE setTextureScaleMode #-}

getTextureScaleMode :: MonadIO m => Texture -> Ptr ScaleMode -> m Bool
getTextureScaleMode tex mode = liftIO $ getTextureScaleModeFFI tex mode
{-# INLINE getTextureScaleMode #-}

updateTexture :: MonadIO m => Texture -> Ptr Rect -> Ptr () -> CInt -> m Bool
updateTexture tex rect pixels pitch = liftIO $ updateTextureFFI tex rect pixels pitch
{-# INLINE updateTexture #-}

updateYUVTexture :: MonadIO m => Texture -> Ptr Rect -> Ptr Word8 -> CInt -> Ptr Word8 -> CInt -> Ptr Word8 -> CInt -> m Bool
updateYUVTexture tex rect yplane ypitch uplane upitch vplane vpitch = liftIO $ updateYUVTextureFFI tex rect yplane ypitch uplane upitch vplane vpitch
{-# INLINE updateYUVTexture #-}

updateNVTexture :: MonadIO m => Texture -> Ptr Rect -> Ptr Word8 -> CInt -> Ptr Word8 -> CInt -> m Bool
updateNVTexture tex rect plane1 pitch1 plane2 pitch2 = liftIO $ updateNVTextureFFI tex rect plane1 pitch1 plane2 pitch2
{-# INLINE updateNVTexture #-}

lockTexture :: MonadIO m => Texture -> Ptr Rect -> Ptr (Ptr ()) -> Ptr CInt -> m Bool
lockTexture tex rect pixels pitch = liftIO $ lockTextureFFI tex rect pixels pitch
{-# INLINE lockTexture #-}

lockTextureToSurface :: MonadIO m => Texture -> Ptr Rect -> Ptr Surface -> m Bool
lockTextureToSurface tex rect surf = liftIO $ lockTextureToSurfaceFFI tex rect surf
{-# INLINE lockTextureToSurface #-}

unlockTexture :: MonadIO m => Texture -> m ()
unlockTexture tex = liftIO $ unlockTextureFFI tex
{-# INLINE unlockTexture #-}

destroyTexture :: MonadIO m => Texture -> m ()
destroyTexture tex = liftIO $ destroyTextureFFI tex
{-# INLINE destroyTexture #-}

setRenderTarget :: MonadIO m => Renderer -> Texture -> m Bool
setRenderTarget rend tex = liftIO $ setRenderTargetFFI rend tex
{-# INLINE setRenderTarget #-}

getRenderTarget :: MonadIO m => Renderer -> m Texture
getRenderTarget rend = liftIO $ getRenderTargetFFI rend
{-# INLINE getRenderTarget #-}

setRenderLogicalPresentation :: MonadIO m => Renderer -> CInt -> CInt -> RendererLogicalPresentation -> ScaleMode -> m Bool
setRenderLogicalPresentation rend w h mode scale = liftIO $ setRenderLogicalPresentationFFI rend w h mode scale
{-# INLINE setRenderLogicalPresentation #-}

getRenderLogicalPresentation :: MonadIO m => Renderer -> Ptr CInt -> Ptr CInt -> Ptr RendererLogicalPresentation -> Ptr ScaleMode -> m Bool
getRenderLogicalPresentation rend w h mode scale = liftIO $ getRenderLogicalPresentationFFI rend w h mode scale
{-# INLINE getRenderLogicalPresentation #-}

getRenderLogicalPresentationRect :: MonadIO m => Renderer -> Ptr FRect -> m Bool
getRenderLogicalPresentationRect rend rect = liftIO $ getRenderLogicalPresentationRectFFI rend rect
{-# INLINE getRenderLogicalPresentationRect #-}

renderCoordinatesToWindow :: MonadIO m => Renderer -> CFloat -> CFloat -> Ptr CFloat -> Ptr CFloat -> m Bool
renderCoordinatesToWindow rend x y winX winY = liftIO $ renderCoordinatesToWindowFFI rend x y winX winY
{-# INLINE renderCoordinatesToWindow #-}

renderCoordinatesFromWindow :: MonadIO m => Renderer -> CFloat -> CFloat -> Ptr CFloat -> Ptr CFloat -> m Bool
renderCoordinatesFromWindow rend winX winY x y = liftIO $ renderCoordinatesFromWindowFFI rend winX winY x y
{-# INLINE renderCoordinatesFromWindow #-}

convertEventToRenderCoordinates :: MonadIO m => Renderer -> Ptr Event -> m Bool
convertEventToRenderCoordinates rend event = liftIO $ convertEventToRenderCoordinatesFFI rend event
{-# INLINE convertEventToRenderCoordinates #-}

setRenderViewport :: MonadIO m => Renderer -> Ptr Rect -> m Bool
setRenderViewport rend rect = liftIO $ setRenderViewportFFI rend rect
{-# INLINE setRenderViewport #-}

getRenderViewport :: MonadIO m => Renderer -> Ptr Rect -> m Bool
getRenderViewport rend rect = liftIO $ getRenderViewportFFI rend rect
{-# INLINE getRenderViewport #-}

renderViewportSet :: MonadIO m => Renderer -> m Bool
renderViewportSet rend = liftIO $ renderViewportSetFFI rend
{-# INLINE renderViewportSet #-}

getRenderSafeArea :: MonadIO m => Renderer -> Ptr Rect -> m Bool
getRenderSafeArea rend rect = liftIO $ getRenderSafeAreaFFI rend rect
{-# INLINE getRenderSafeArea #-}

setRenderClipRect :: MonadIO m => Renderer -> Ptr Rect -> m Bool
setRenderClipRect rend rect = liftIO $ setRenderClipRectFFI rend rect
{-# INLINE setRenderClipRect #-}

getRenderClipRect :: MonadIO m => Renderer -> Ptr Rect -> m Bool
getRenderClipRect rend rect = liftIO $ getRenderClipRectFFI rend rect
{-# INLINE getRenderClipRect #-}

renderClipEnabled :: MonadIO m => Renderer -> m Bool
renderClipEnabled rend = liftIO $ renderClipEnabledFFI rend
{-# INLINE renderClipEnabled #-}

setRenderScale :: MonadIO m => Renderer -> CFloat -> CFloat -> m Bool
setRenderScale rend scaleX scaleY = liftIO $ setRenderScaleFFI rend scaleX scaleY
{-# INLINE setRenderScale #-}

getRenderScale :: MonadIO m => Renderer -> Ptr CFloat -> Ptr CFloat -> m Bool
getRenderScale rend scaleX scaleY = liftIO $ getRenderScaleFFI rend scaleX scaleY
{-# INLINE getRenderScale #-}

setRenderDrawColor :: MonadIO m => Renderer -> Word8 -> Word8 -> Word8 -> Word8 -> m Bool
setRenderDrawColor rend r g b a = liftIO $ setRenderDrawColorFFI rend r g b a
{-# INLINE setRenderDrawColor #-}

setRenderDrawColorFloat :: MonadIO m => Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> m Bool
setRenderDrawColorFloat rend r g b a = liftIO $ setRenderDrawColorFloatFFI rend r g b a
{-# INLINE setRenderDrawColorFloat #-}

getRenderDrawColor :: MonadIO m => Renderer -> Ptr Word8 -> Ptr Word8 -> Ptr Word8 -> Ptr Word8 -> m Bool
getRenderDrawColor rend r g b a = liftIO $ getRenderDrawColorFFI rend r g b a
{-# INLINE getRenderDrawColor #-}

getRenderDrawColorFloat :: MonadIO m => Renderer -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> m Bool
getRenderDrawColorFloat rend r g b a = liftIO $ getRenderDrawColorFloatFFI rend r g b a
{-# INLINE getRenderDrawColorFloat #-}

setRenderColorScale :: MonadIO m => Renderer -> CFloat -> m Bool
setRenderColorScale rend scale = liftIO $ setRenderColorScaleFFI rend scale
{-# INLINE setRenderColorScale #-}

getRenderColorScale :: MonadIO m => Renderer -> Ptr CFloat -> m Bool
getRenderColorScale rend scale = liftIO $ getRenderColorScaleFFI rend scale
{-# INLINE getRenderColorScale #-}

setRenderDrawBlendMode :: MonadIO m => Renderer -> BlendMode -> m Bool
setRenderDrawBlendMode rend mode = liftIO $ setRenderDrawBlendModeFFI rend mode
{-# INLINE setRenderDrawBlendMode #-}

getRenderDrawBlendMode :: MonadIO m => Renderer -> Ptr BlendMode -> m Bool
getRenderDrawBlendMode rend mode = liftIO $ getRenderDrawBlendModeFFI rend mode
{-# INLINE getRenderDrawBlendMode #-}

renderClear :: MonadIO m => Renderer -> m Bool
renderClear rend = liftIO $ renderClearFFI rend
{-# INLINE renderClear #-}

renderPoint :: MonadIO m => Renderer -> CFloat -> CFloat -> m Bool
renderPoint rend x y = liftIO $ renderPointFFI rend x y
{-# INLINE renderPoint #-}

renderPoints :: MonadIO m => Renderer -> Ptr FPoint -> CInt -> m Bool
renderPoints rend points count = liftIO $ renderPointsFFI rend points count
{-# INLINE renderPoints #-}

renderLine :: MonadIO m => Renderer -> CFloat -> CFloat -> CFloat -> CFloat -> m Bool
renderLine rend x1 y1 x2 y2 = liftIO $ renderLineFFI rend x1 y1 x2 y2
{-# INLINE renderLine #-}

renderLines :: MonadIO m => Renderer -> Ptr FPoint -> CInt -> m Bool
renderLines rend points count = liftIO $ renderLinesFFI rend points count
{-# INLINE renderLines #-}

renderRect :: MonadIO m => Renderer -> Ptr FRect -> m Bool
renderRect rend rect = liftIO $ renderRectFFI rend rect
{-# INLINE renderRect #-}

renderRects :: MonadIO m => Renderer -> Ptr FRect -> CInt -> m Bool
renderRects rend rects count = liftIO $ renderRectsFFI rend rects count
{-# INLINE renderRects #-}

renderFillRect :: MonadIO m => Renderer -> Ptr FRect -> m Bool
renderFillRect rend rect = liftIO $ renderFillRectFFI rend rect
{-# INLINE renderFillRect #-}

renderFillRects :: MonadIO m => Renderer -> Ptr FRect -> CInt -> m Bool
renderFillRects rend rects count = liftIO $ renderFillRectsFFI rend rects count
{-# INLINE renderFillRects #-}

renderTexture :: MonadIO m => Renderer -> Texture -> Ptr FRect -> Ptr FRect -> m Bool
renderTexture rend tex src dst = liftIO $ renderTextureFFI rend tex src dst
{-# INLINE renderTexture #-}

renderTextureRotated :: MonadIO m => Renderer -> Texture -> Ptr FRect -> Ptr FRect -> CDouble -> Ptr FPoint -> FlipMode -> m Bool
renderTextureRotated rend tex src dst angle center flip = liftIO $ renderTextureRotatedFFI rend tex src dst angle center flip
{-# INLINE renderTextureRotated #-}

renderTextureAffine :: MonadIO m => Renderer -> Texture -> Ptr FRect -> Ptr FPoint -> Ptr FPoint -> Ptr FPoint -> m Bool
renderTextureAffine rend tex src origin right down = liftIO $ renderTextureAffineFFI rend tex src origin right down
{-# INLINE renderTextureAffine #-}

renderTextureTiled :: MonadIO m => Renderer -> Texture -> Ptr FRect -> CFloat -> Ptr FRect -> m Bool
renderTextureTiled rend tex src scale dst = liftIO $ renderTextureTiledFFI rend tex src scale dst
{-# INLINE renderTextureTiled #-}

renderTexture9Grid :: MonadIO m => Renderer -> Texture -> Ptr FRect -> CFloat -> CFloat -> CFloat -> CFloat -> CFloat -> Ptr FRect -> m Bool
renderTexture9Grid rend tex src leftW rightW topH bottomH scale dst = liftIO $ renderTexture9GridFFI rend tex src leftW rightW topH bottomH scale dst
{-# INLINE renderTexture9Grid #-}

renderTexture9GridTiled :: MonadIO m => Renderer -> Texture -> Ptr FRect -> CFloat -> CFloat -> CFloat -> CFloat -> CFloat -> Ptr FRect -> CFloat -> m Bool
renderTexture9GridTiled rend tex src leftW rightW topH bottomH scale dst tileScale = liftIO $ renderTexture9GridTiledFFI rend tex src leftW rightW topH bottomH scale dst tileScale
{-# INLINE renderTexture9GridTiled #-}

renderGeometry :: MonadIO m => Renderer -> Texture -> Ptr Vertex -> CInt -> Ptr CInt -> CInt -> m Bool
renderGeometry rend tex vertices numV indices numI = liftIO $ renderGeometryFFI rend tex vertices numV indices numI
{-# INLINE renderGeometry #-}

renderGeometryRaw :: MonadIO m => Renderer -> Texture -> Ptr CFloat -> CInt -> Ptr FColor -> CInt -> Ptr CFloat -> CInt -> CInt -> Ptr () -> CInt -> CInt -> m Bool
renderGeometryRaw rend tex xy xyStride color colorStride uv uvStride numV indices numI sizeI = liftIO $ renderGeometryRawFFI rend tex xy xyStride color colorStride uv uvStride numV indices numI sizeI
{-# INLINE renderGeometryRaw #-}

renderReadPixels :: MonadIO m => Renderer -> Ptr Rect -> m (Ptr Surface)
renderReadPixels rend rect = liftIO $ renderReadPixelsFFI rend rect
{-# INLINE renderReadPixels #-}

renderPresent :: MonadIO m => Renderer -> m Bool
renderPresent rend = liftIO $ renderPresentFFI rend
{-# INLINE renderPresent #-}

getRenderMetalLayer :: MonadIO m => Renderer -> m (Ptr ())
getRenderMetalLayer rend = liftIO $ getRenderMetalLayerFFI rend
{-# INLINE getRenderMetalLayer #-}

getRenderMetalCommandEncoder :: MonadIO m => Renderer -> m (Ptr ())
getRenderMetalCommandEncoder rend = liftIO $ getRenderMetalCommandEncoderFFI rend
{-# INLINE getRenderMetalCommandEncoder #-}

addVulkanRenderSemaphores :: MonadIO m => Renderer -> Word32 -> Int64 -> Int64 -> m Bool
addVulkanRenderSemaphores rend waitMask waitSem signalSem = liftIO $ addVulkanRenderSemaphoresFFI rend waitMask waitSem signalSem
{-# INLINE addVulkanRenderSemaphores #-}

setRenderVSync :: MonadIO m => Renderer -> CInt -> m Bool
setRenderVSync rend vsync = liftIO $ setRenderVSyncFFI rend vsync
{-# INLINE setRenderVSync #-}

getRenderVSync :: MonadIO m => Renderer -> Ptr CInt -> m Bool
getRenderVSync rend vsync = liftIO $ getRenderVSyncFFI rend vsync
{-# INLINE getRenderVSync #-}

renderDebugText :: MonadIO m => Renderer -> CFloat -> CFloat -> CString -> m Bool
renderDebugText rend x y str = liftIO $ renderDebugTextFFI rend x y str
{-# INLINE renderDebugText #-}

renderDebugTextFormat :: MonadIO m => Renderer -> CFloat -> CFloat -> CString -> m Bool
renderDebugTextFormat rend x y fmt = liftIO $ renderDebugTextFormatFFI rend x y fmt -- Variadic simplified
{-# INLINE renderDebugTextFormat #-}

setDefaultTextureScaleMode :: MonadIO m => Renderer -> ScaleMode -> m Bool
setDefaultTextureScaleMode rend mode = liftIO $ setDefaultTextureScaleModeFFI rend mode
{-# INLINE setDefaultTextureScaleMode #-}

getDefaultTextureScaleMode :: MonadIO m => Renderer -> Ptr ScaleMode -> m Bool
getDefaultTextureScaleMode rend mode = liftIO $ getDefaultTextureScaleModeFFI rend mode
{-# INLINE getDefaultTextureScaleMode #-}

createGPURenderState :: MonadIO m => Renderer -> Ptr GPURenderStateDesc -> m GPURenderState
createGPURenderState rend desc = liftIO $ createGPURenderStateFFI rend desc
{-# INLINE createGPURenderState #-}

setGPURenderStateFragmentUniforms :: MonadIO m => GPURenderState -> Word32 -> Ptr () -> Word32 -> m Bool
setGPURenderStateFragmentUniforms state slot data1 len = liftIO $ setGPURenderStateFragmentUniformsFFI state slot data1 len
{-# INLINE setGPURenderStateFragmentUniforms #-}

setRenderGPUState :: MonadIO m => Renderer -> GPURenderState -> m Bool
setRenderGPUState rend state = liftIO $ setRenderGPUStateFFI rend state
{-# INLINE setRenderGPUState #-}

destroyGPURenderState :: MonadIO m => GPURenderState -> m ()
destroyGPURenderState state = liftIO $ destroyGPURenderStateFFI state
{-# INLINE destroyGPURenderState #-}
