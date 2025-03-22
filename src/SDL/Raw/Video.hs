{-# LANGUAGE CPP #-}

module SDL.Raw.Video (
  -- * Display and Window Management
  createWindow,
  createPopupWindow,
  createWindowWithProperties,
  destroyWindow,
  disableScreenSaver,
  enableScreenSaver,
  getClosestFullscreenDisplayMode,
  getCurrentDisplayMode,
  getCurrentVideoDriver,
  getDesktopDisplayMode,
  getDisplayBounds,
  getDisplayContentScale,
  getDisplays,
  getDisplayName,
  getDisplayUsableBounds,
  getDisplayForPoint,
  getDisplayForRect,
  getDisplayForWindow,
  getGrabbedWindow,
  getNumVideoDrivers,
  getVideoDriver,
  getPrimaryDisplay,
  getWindowBordersSize,
  getWindowDisplayScale,
  getWindowFlags,
  getWindowFromID,
  getWindowID,
  getWindowOpacity,
  getWindowParent,
  getWindowPixelDensity,
  getWindowPixelFormat,
  getWindowPosition,
  getWindowSafeArea,
  getWindowSize,
  getWindowSizeInPixels,
  getWindowSurface,
  getWindowSurfaceVSync,
  getWindowTitle,
  hideWindow,
  screenSaverEnabled,
  maximizeWindow,
  minimizeWindow,
  raiseWindow,
  restoreWindow,
  setWindowAlwaysOnTop,
  setWindowBordered,
  setWindowFocusable,
  setWindowFullscreen,
  setWindowFullscreenMode,
  setWindowIcon,
  setWindowKeyboardGrab,
  setWindowMaximumSize,
  setWindowMinimumSize,
  setWindowMouseGrab,
  setWindowMouseRect,
  setWindowOpacity,
  setWindowPosition,
  setWindowResizable,
  setWindowSize,
  setWindowSurfaceVSync,
  setWindowTitle,
  showMessageBox,
  showSimpleMessageBox,
  showWindow,
  showWindowSystemMenu,
  syncWindow,
  updateWindowSurface,
  updateWindowSurfaceRects,
  windowHasSurface,

  -- * Clipboard Handling
  getClipboardText,
  hasClipboardText,
  setClipboardText
) where

import Control.Monad.IO.Class
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import SDL.Raw.Types

-- Display and Window Management
foreign import ccall "SDL3/SDL.h SDL_CreateWindow" createWindowFFI :: CString -> CInt -> CInt -> Word64 -> IO Window
foreign import ccall "SDL3/SDL.h SDL_CreatePopupWindow" createPopupWindowFFI :: Window -> CInt -> CInt -> CInt -> CInt -> Word64 -> IO Window
foreign import ccall "SDL3/SDL.h SDL_CreateWindowWithProperties" createWindowWithPropertiesFFI :: PropertiesID -> IO Window
foreign import ccall "SDL3/SDL.h SDL_DestroyWindow" destroyWindowFFI :: Window -> IO ()
foreign import ccall "SDL3/SDL.h SDL_DisableScreenSaver" disableScreenSaverFFI :: IO Bool
foreign import ccall "SDL3/SDL.h SDL_EnableScreenSaver" enableScreenSaverFFI :: IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetClosestFullscreenDisplayMode" getClosestFullscreenDisplayModeFFI :: DisplayID -> CInt -> CInt -> CFloat -> Bool -> Ptr DisplayMode -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetCurrentDisplayMode" getCurrentDisplayModeFFI :: DisplayID -> IO (Ptr DisplayMode)
foreign import ccall "SDL3/SDL.h SDL_GetCurrentVideoDriver" getCurrentVideoDriverFFI :: IO CString
foreign import ccall "SDL3/SDL.h SDL_GetDesktopDisplayMode" getDesktopDisplayModeFFI :: DisplayID -> IO (Ptr DisplayMode)
foreign import ccall "SDL3/SDL.h SDL_GetDisplayBounds" getDisplayBoundsFFI :: DisplayID -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetDisplayContentScale" getDisplayContentScaleFFI :: DisplayID -> IO CFloat
foreign import ccall "SDL3/SDL.h SDL_GetDisplays" getDisplaysFFI :: Ptr CInt -> IO (Ptr DisplayID)
foreign import ccall "SDL3/SDL.h SDL_GetDisplayName" getDisplayNameFFI :: DisplayID -> IO CString
foreign import ccall "SDL3/SDL.h SDL_GetDisplayUsableBounds" getDisplayUsableBoundsFFI :: DisplayID -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetDisplayForPoint" getDisplayForPointFFI :: Ptr Point -> IO DisplayID
foreign import ccall "SDL3/SDL.h SDL_GetDisplayForRect" getDisplayForRectFFI :: Ptr Rect -> IO DisplayID
foreign import ccall "SDL3/SDL.h SDL_GetDisplayForWindow" getDisplayForWindowFFI :: Window -> IO DisplayID
foreign import ccall "SDL3/SDL.h SDL_GetGrabbedWindow" getGrabbedWindowFFI :: IO Window
foreign import ccall "SDL3/SDL.h SDL_GetNumVideoDrivers" getNumVideoDriversFFI :: IO CInt
foreign import ccall "SDL3/SDL.h SDL_GetVideoDriver" getVideoDriverFFI :: CInt -> IO CString
foreign import ccall "SDL3/SDL.h SDL_GetPrimaryDisplay" getPrimaryDisplayFFI :: IO DisplayID
foreign import ccall "SDL3/SDL.h SDL_GetWindowBordersSize" getWindowBordersSizeFFI :: Window -> Ptr CInt -> Ptr CInt -> Ptr CInt -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetWindowDisplayScale" getWindowDisplayScaleFFI :: Window -> IO CFloat
foreign import ccall "SDL3/SDL.h SDL_GetWindowFlags" getWindowFlagsFFI :: Window -> IO Word64
foreign import ccall "SDL3/SDL.h SDL_GetWindowFromID" getWindowFromIDFFI :: WindowID -> IO Window
foreign import ccall "SDL3/SDL.h SDL_GetWindowID" getWindowIDFFI :: Window -> IO WindowID
foreign import ccall "SDL3/SDL.h SDL_GetWindowOpacity" getWindowOpacityFFI :: Window -> IO CFloat
foreign import ccall "SDL3/SDL.h SDL_GetWindowParent" getWindowParentFFI :: Window -> IO Window
foreign import ccall "SDL3/SDL.h SDL_GetWindowPixelDensity" getWindowPixelDensityFFI :: Window -> IO CFloat
foreign import ccall "SDL3/SDL.h SDL_GetWindowPixelFormat" getWindowPixelFormatFFI :: Window -> IO PixelFormat
foreign import ccall "SDL3/SDL.h SDL_GetWindowPosition" getWindowPositionFFI :: Window -> Ptr CInt -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetWindowSafeArea" getWindowSafeAreaFFI :: Window -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetWindowSize" getWindowSizeFFI :: Window -> Ptr CInt -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetWindowSizeInPixels" getWindowSizeInPixelsFFI :: Window -> Ptr CInt -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetWindowSurface" getWindowSurfaceFFI :: Window -> IO (Ptr Surface)
foreign import ccall "SDL3/SDL.h SDL_GetWindowSurfaceVSync" getWindowSurfaceVSyncFFI :: Window -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetWindowTitle" getWindowTitleFFI :: Window -> IO CString
foreign import ccall "SDL3/SDL.h SDL_HideWindow" hideWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_ScreenSaverEnabled" screenSaverEnabledFFI :: IO Bool
foreign import ccall "SDL3/SDL.h SDL_MaximizeWindow" maximizeWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_MinimizeWindow" minimizeWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_RaiseWindow" raiseWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_RestoreWindow" restoreWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowAlwaysOnTop" setWindowAlwaysOnTopFFI :: Window -> Bool -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowBordered" setWindowBorderedFFI :: Window -> Bool -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowFocusable" setWindowFocusableFFI :: Window -> Bool -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowFullscreen" setWindowFullscreenFFI :: Window -> Bool -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowFullscreenMode" setWindowFullscreenModeFFI :: Window -> Ptr DisplayMode -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowIcon" setWindowIconFFI :: Window -> Ptr Surface -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowKeyboardGrab" setWindowKeyboardGrabFFI :: Window -> Bool -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowMaximumSize" setWindowMaximumSizeFFI :: Window -> CInt -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowMinimumSize" setWindowMinimumSizeFFI :: Window -> CInt -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowMouseGrab" setWindowMouseGrabFFI :: Window -> Bool -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowMouseRect" setWindowMouseRectFFI :: Window -> Ptr Rect -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowOpacity" setWindowOpacityFFI :: Window -> CFloat -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowPosition" setWindowPositionFFI :: Window -> CInt -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowResizable" setWindowResizableFFI :: Window -> Bool -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowSize" setWindowSizeFFI :: Window -> CInt -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowSurfaceVSync" setWindowSurfaceVSyncFFI :: Window -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetWindowTitle" setWindowTitleFFI :: Window -> CString -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_ShowMessageBox" showMessageBoxFFI :: Ptr MessageBoxData -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_ShowSimpleMessageBox" showSimpleMessageBoxFFI :: Word32 -> CString -> CString -> Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_ShowWindow" showWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_ShowWindowSystemMenu" showWindowSystemMenuFFI :: Window -> CInt -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_SyncWindow" syncWindowFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_UpdateWindowSurface" updateWindowSurfaceFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_UpdateWindowSurfaceRects" updateWindowSurfaceRectsFFI :: Window -> Ptr Rect -> CInt -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_WindowHasSurface" windowHasSurfaceFFI :: Window -> IO Bool

-- Clipboard Handling
foreign import ccall "SDL3/SDL.h SDL_GetClipboardText" getClipboardTextFFI :: IO CString
foreign import ccall "SDL3/SDL.h SDL_HasClipboardText" hasClipboardTextFFI :: IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetClipboardText" setClipboardTextFFI :: CString -> IO Bool

-- Function wrappers
createWindow :: MonadIO m => CString -> CInt -> CInt -> Word64 -> m Window
createWindow title w h flags = liftIO $ createWindowFFI title w h flags
{-# INLINE createWindow #-}

createPopupWindow :: MonadIO m => Window -> CInt -> CInt -> CInt -> CInt -> Word64 -> m Window
createPopupWindow parent offset_x offset_y w h flags = liftIO $ createPopupWindowFFI parent offset_x offset_y w h flags
{-# INLINE createPopupWindow #-}

createWindowWithProperties :: MonadIO m => PropertiesID -> m Window
createWindowWithProperties props = liftIO $ createWindowWithPropertiesFFI props
{-# INLINE createWindowWithProperties #-}

destroyWindow :: MonadIO m => Window -> m ()
destroyWindow window = liftIO $ destroyWindowFFI window
{-# INLINE destroyWindow #-}

disableScreenSaver :: MonadIO m => m Bool
disableScreenSaver = liftIO disableScreenSaverFFI
{-# INLINE disableScreenSaver #-}

enableScreenSaver :: MonadIO m => m Bool
enableScreenSaver = liftIO enableScreenSaverFFI
{-# INLINE enableScreenSaver #-}

getClosestFullscreenDisplayMode :: MonadIO m => DisplayID -> CInt -> CInt -> CFloat -> Bool -> Ptr DisplayMode -> m Bool
getClosestFullscreenDisplayMode displayID w h refresh_rate include_high_density_modes closest = 
    liftIO $ getClosestFullscreenDisplayModeFFI displayID w h refresh_rate include_high_density_modes closest
{-# INLINE getClosestFullscreenDisplayMode #-}

getCurrentDisplayMode :: MonadIO m => DisplayID -> m (Ptr DisplayMode)
getCurrentDisplayMode displayID = liftIO $ getCurrentDisplayModeFFI displayID
{-# INLINE getCurrentDisplayMode #-}

getCurrentVideoDriver :: MonadIO m => m CString
getCurrentVideoDriver = liftIO getCurrentVideoDriverFFI
{-# INLINE getCurrentVideoDriver #-}

getDesktopDisplayMode :: MonadIO m => DisplayID -> m (Ptr DisplayMode)
getDesktopDisplayMode displayID = liftIO $ getDesktopDisplayModeFFI displayID
{-# INLINE getDesktopDisplayMode #-}

getDisplayBounds :: MonadIO m => DisplayID -> Ptr Rect -> m Bool
getDisplayBounds displayID rect = liftIO $ getDisplayBoundsFFI displayID rect
{-# INLINE getDisplayBounds #-}

getDisplayContentScale :: MonadIO m => DisplayID -> m CFloat
getDisplayContentScale displayID = liftIO $ getDisplayContentScaleFFI displayID
{-# INLINE getDisplayContentScale #-}

getDisplays :: MonadIO m => Ptr CInt -> m (Ptr DisplayID)
getDisplays count = liftIO $ getDisplaysFFI count
{-# INLINE getDisplays #-}

getDisplayName :: MonadIO m => DisplayID -> m CString
getDisplayName displayID = liftIO $ getDisplayNameFFI displayID
{-# INLINE getDisplayName #-}

getDisplayUsableBounds :: MonadIO m => DisplayID -> Ptr Rect -> m Bool
getDisplayUsableBounds displayID rect = liftIO $ getDisplayUsableBoundsFFI displayID rect
{-# INLINE getDisplayUsableBounds #-}

getDisplayForPoint :: MonadIO m => Ptr Point -> m DisplayID
getDisplayForPoint point = liftIO $ getDisplayForPointFFI point
{-# INLINE getDisplayForPoint #-}

getDisplayForRect :: MonadIO m => Ptr Rect -> m DisplayID
getDisplayForRect rect = liftIO $ getDisplayForRectFFI rect
{-# INLINE getDisplayForRect #-}

getDisplayForWindow :: MonadIO m => Window -> m DisplayID
getDisplayForWindow window = liftIO $ getDisplayForWindowFFI window
{-# INLINE getDisplayForWindow #-}

getGrabbedWindow :: MonadIO m => m Window
getGrabbedWindow = liftIO getGrabbedWindowFFI
{-# INLINE getGrabbedWindow #-}

getNumVideoDrivers :: MonadIO m => m CInt
getNumVideoDrivers = liftIO getNumVideoDriversFFI
{-# INLINE getNumVideoDrivers #-}

getVideoDriver :: MonadIO m => CInt -> m CString
getVideoDriver index = liftIO $ getVideoDriverFFI index
{-# INLINE getVideoDriver #-}

getPrimaryDisplay :: MonadIO m => m DisplayID
getPrimaryDisplay = liftIO getPrimaryDisplayFFI
{-# INLINE getPrimaryDisplay #-}

getWindowBordersSize :: MonadIO m => Window -> Ptr CInt -> Ptr CInt -> Ptr CInt -> Ptr CInt -> m Bool
getWindowBordersSize window top left bottom right = 
    liftIO $ getWindowBordersSizeFFI window top left bottom right
{-# INLINE getWindowBordersSize #-}

getWindowDisplayScale :: MonadIO m => Window -> m CFloat
getWindowDisplayScale window = liftIO $ getWindowDisplayScaleFFI window
{-# INLINE getWindowDisplayScale #-}

getWindowFlags :: MonadIO m => Window -> m Word64
getWindowFlags window = liftIO $ getWindowFlagsFFI window
{-# INLINE getWindowFlags #-}

getWindowFromID :: MonadIO m => WindowID -> m Window
getWindowFromID id = liftIO $ getWindowFromIDFFI id
{-# INLINE getWindowFromID #-}

getWindowID :: MonadIO m => Window -> m WindowID
getWindowID window = liftIO $ getWindowIDFFI window
{-# INLINE getWindowID #-}

getWindowOpacity :: MonadIO m => Window -> m CFloat
getWindowOpacity window = liftIO $ getWindowOpacityFFI window
{-# INLINE getWindowOpacity #-}

getWindowParent :: MonadIO m => Window -> m Window
getWindowParent window = liftIO $ getWindowParentFFI window
{-# INLINE getWindowParent #-}

getWindowPixelDensity :: MonadIO m => Window -> m CFloat
getWindowPixelDensity window = liftIO $ getWindowPixelDensityFFI window
{-# INLINE getWindowPixelDensity #-}

getWindowPixelFormat :: MonadIO m => Window -> m PixelFormat
getWindowPixelFormat window = liftIO $ getWindowPixelFormatFFI window
{-# INLINE getWindowPixelFormat #-}

getWindowPosition :: MonadIO m => Window -> Ptr CInt -> Ptr CInt -> m Bool
getWindowPosition window x y = liftIO $ getWindowPositionFFI window x y
{-# INLINE getWindowPosition #-}

getWindowSafeArea :: MonadIO m => Window -> Ptr Rect -> m Bool
getWindowSafeArea window rect = liftIO $ getWindowSafeAreaFFI window rect
{-# INLINE getWindowSafeArea #-}

getWindowSize :: MonadIO m => Window -> Ptr CInt -> Ptr CInt -> m Bool
getWindowSize window w h = liftIO $ getWindowSizeFFI window w h
{-# INLINE getWindowSize #-}

getWindowSizeInPixels :: MonadIO m => Window -> Ptr CInt -> Ptr CInt -> m Bool
getWindowSizeInPixels window w h = liftIO $ getWindowSizeInPixelsFFI window w h
{-# INLINE getWindowSizeInPixels #-}

getWindowSurface :: MonadIO m => Window -> m (Ptr Surface)
getWindowSurface window = liftIO $ getWindowSurfaceFFI window
{-# INLINE getWindowSurface #-}

getWindowSurfaceVSync :: MonadIO m => Window -> Ptr CInt -> m Bool
getWindowSurfaceVSync window vsync = liftIO $ getWindowSurfaceVSyncFFI window vsync
{-# INLINE getWindowSurfaceVSync #-}

getWindowTitle :: MonadIO m => Window -> m CString
getWindowTitle window = liftIO $ getWindowTitleFFI window
{-# INLINE getWindowTitle #-}

hideWindow :: MonadIO m => Window -> m Bool
hideWindow window = liftIO $ hideWindowFFI window
{-# INLINE hideWindow #-}

screenSaverEnabled :: MonadIO m => m Bool
screenSaverEnabled = liftIO screenSaverEnabledFFI
{-# INLINE screenSaverEnabled #-}

maximizeWindow :: MonadIO m => Window -> m Bool
maximizeWindow window = liftIO $ maximizeWindowFFI window
{-# INLINE maximizeWindow #-}

minimizeWindow :: MonadIO m => Window -> m Bool
minimizeWindow window = liftIO $ minimizeWindowFFI window
{-# INLINE minimizeWindow #-}

raiseWindow :: MonadIO m => Window -> m Bool
raiseWindow window = liftIO $ raiseWindowFFI window
{-# INLINE raiseWindow #-}

restoreWindow :: MonadIO m => Window -> m Bool
restoreWindow window = liftIO $ restoreWindowFFI window
{-# INLINE restoreWindow #-}

setWindowAlwaysOnTop :: MonadIO m => Window -> Bool -> m Bool
setWindowAlwaysOnTop window on_top = liftIO $ setWindowAlwaysOnTopFFI window on_top
{-# INLINE setWindowAlwaysOnTop #-}

setWindowBordered :: MonadIO m => Window -> Bool -> m Bool
setWindowBordered window bordered = liftIO $ setWindowBorderedFFI window bordered
{-# INLINE setWindowBordered #-}

setWindowFocusable :: MonadIO m => Window -> Bool -> m Bool
setWindowFocusable window focusable = liftIO $ setWindowFocusableFFI window focusable
{-# INLINE setWindowFocusable #-}

setWindowFullscreen :: MonadIO m => Window -> Bool -> m Bool
setWindowFullscreen window fullscreen = liftIO $ setWindowFullscreenFFI window fullscreen
{-# INLINE setWindowFullscreen #-}

setWindowFullscreenMode :: MonadIO m => Window -> Ptr DisplayMode -> m Bool
setWindowFullscreenMode window mode = liftIO $ setWindowFullscreenModeFFI window mode
{-# INLINE setWindowFullscreenMode #-}

setWindowIcon :: MonadIO m => Window -> Ptr Surface -> m Bool
setWindowIcon window icon = liftIO $ setWindowIconFFI window icon
{-# INLINE setWindowIcon #-}

setWindowKeyboardGrab :: MonadIO m => Window -> Bool -> m Bool
setWindowKeyboardGrab window grabbed = liftIO $ setWindowKeyboardGrabFFI window grabbed
{-# INLINE setWindowKeyboardGrab #-}

setWindowMaximumSize :: MonadIO m => Window -> CInt -> CInt -> m Bool
setWindowMaximumSize window max_w max_h = liftIO $ setWindowMaximumSizeFFI window max_w max_h
{-# INLINE setWindowMaximumSize #-}

setWindowMinimumSize :: MonadIO m => Window -> CInt -> CInt -> m Bool
setWindowMinimumSize window min_w min_h = liftIO $ setWindowMinimumSizeFFI window min_w min_h
{-# INLINE setWindowMinimumSize #-}

setWindowMouseGrab :: MonadIO m => Window -> Bool -> m Bool
setWindowMouseGrab window grabbed = liftIO $ setWindowMouseGrabFFI window grabbed
{-# INLINE setWindowMouseGrab #-}

setWindowMouseRect :: MonadIO m => Window -> Ptr Rect -> m Bool
setWindowMouseRect window rect = liftIO $ setWindowMouseRectFFI window rect
{-# INLINE setWindowMouseRect #-}

setWindowOpacity :: MonadIO m => Window -> CFloat -> m Bool
setWindowOpacity window opacity = liftIO $ setWindowOpacityFFI window opacity
{-# INLINE setWindowOpacity #-}

setWindowPosition :: MonadIO m => Window -> CInt -> CInt -> m Bool
setWindowPosition window x y = liftIO $ setWindowPositionFFI window x y
{-# INLINE setWindowPosition #-}

setWindowResizable :: MonadIO m => Window -> Bool -> m Bool
setWindowResizable window resizable = liftIO $ setWindowResizableFFI window resizable
{-# INLINE setWindowResizable #-}

setWindowSize :: MonadIO m => Window -> CInt -> CInt -> m Bool
setWindowSize window w h = liftIO $ setWindowSizeFFI window w h
{-# INLINE setWindowSize #-}

setWindowSurfaceVSync :: MonadIO m => Window -> CInt -> m Bool
setWindowSurfaceVSync window vsync = liftIO $ setWindowSurfaceVSyncFFI window vsync
{-# INLINE setWindowSurfaceVSync #-}

setWindowTitle :: MonadIO m => Window -> CString -> m Bool
setWindowTitle window title = liftIO $ setWindowTitleFFI window title
{-# INLINE setWindowTitle #-}

showMessageBox :: MonadIO m => Ptr MessageBoxData -> Ptr CInt -> m Bool
showMessageBox messageboxdata buttonid = liftIO $ showMessageBoxFFI messageboxdata buttonid
{-# INLINE showMessageBox #-}

showSimpleMessageBox :: MonadIO m => Word32 -> CString -> CString -> Window -> m Bool
showSimpleMessageBox flags title message window = 
    liftIO $ showSimpleMessageBoxFFI flags title message window
{-# INLINE showSimpleMessageBox #-}

showWindow :: MonadIO m => Window -> m Bool
showWindow window = liftIO $ showWindowFFI window
{-# INLINE showWindow #-}

showWindowSystemMenu :: MonadIO m => Window -> CInt -> CInt -> m Bool
showWindowSystemMenu window x y = liftIO $ showWindowSystemMenuFFI window x y
{-# INLINE showWindowSystemMenu #-}

syncWindow :: MonadIO m => Window -> m Bool
syncWindow window = liftIO $ syncWindowFFI window
{-# INLINE syncWindow #-}

updateWindowSurface :: MonadIO m => Window -> m Bool
updateWindowSurface window = liftIO $ updateWindowSurfaceFFI window
{-# INLINE updateWindowSurface #-}

updateWindowSurfaceRects :: MonadIO m => Window -> Ptr Rect -> CInt -> m Bool
updateWindowSurfaceRects window rects numrects = 
    liftIO $ updateWindowSurfaceRectsFFI window rects numrects
{-# INLINE updateWindowSurfaceRects #-}

windowHasSurface :: MonadIO m => Window -> m Bool
windowHasSurface window = liftIO $ windowHasSurfaceFFI window
{-# INLINE windowHasSurface #-}

getClipboardText :: MonadIO m => m CString
getClipboardText = liftIO getClipboardTextFFI
{-# INLINE getClipboardText #-}

hasClipboardText :: MonadIO m => m Bool
hasClipboardText = liftIO hasClipboardTextFFI
{-# INLINE hasClipboardText #-}

setClipboardText :: MonadIO m => CString -> m Bool
setClipboardText text = liftIO $ setClipboardTextFFI text
{-# INLINE setClipboardText #-}
