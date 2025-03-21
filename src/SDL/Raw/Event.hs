module SDL.Raw.Event (
  -- * Event Handling
  addEventWatch,
  delEventWatch,
  eventState,
  filterEvents,
  flushEvent,
  flushEvents,
  getEventFilter,
  getNumTouchDevices,
  getNumTouchFingers,
  getTouchDevice,
  getTouchFinger,
  hasEvent,
  hasEvents,
  peepEvents,
  pollEvent,
  pumpEvents,
  pushEvent,
  quitRequested,
  recordGesture,
  registerEvents,
  setEventFilter,
  waitEventTimeout,

  -- * Keyboard Support
  getKeyFromName,
  getKeyFromScancode,
  getKeyName,
  getKeyboardFocus,
  getKeyboardState,
  getModState,
  getScancodeFromKey,
  getScancodeFromName,
  getScancodeName,
  hasScreenKeyboardSupport,
  isScreenKeyboardShown,
  isTextInputActive,
  setModState,
  setTextInputRect,
  startTextInput,
  stopTextInput,

  -- * Mouse Support
  captureMouse,
  createColorCursor,
  createCursor,
  createSystemCursor,
  freeCursor,
  getCursor,
  getDefaultCursor,
  getGlobalMouseState,
  getMouseFocus,
  getMouseState,
  getRelativeMouseMode,
  getRelativeMouseState,
  setCursor,
  setRelativeMouseMode,
  showCursor,
  warpMouseGlobal,
  warpMouseInWindow,

  -- * Gamepad Support
  gamepadAddMapping,
  gamepadAddMappingsFromFile,
  gamepadAddMappingsFromRW,
  gamepadClose,
  gamepadEventState,
  gamepadFromInstanceID,
  gamepadGetAttached,
  gamepadGetAxis,
  gamepadGetAxisFromString,
  gamepadGetBindForAxis,
  gamepadGetBindForButton,
  gamepadGetButton,
  gamepadGetButtonFromString,
  gamepadGetJoystick,
  gamepadGetStringForAxis,
  gamepadGetStringForButton,
  gamepadMapping,
  gamepadMappingForGUID,
  gamepadName,
  gamepadNameForIndex,
  gamepadOpen,
  gamepadUpdate,
  isGamepad,
  eventBuffer,
  eventBufferSize
) where

import Control.Monad.IO.Class
import Data.Int
import Data.Word
import Foreign.C.String
import Foreign.C.Types
import Foreign.Marshal.Alloc
import Foreign.Ptr
import Foreign.Storable
import SDL.Raw.Enum
import SDL.Raw.Filesystem
import SDL.Raw.Types

foreign import ccall "SDL3/SDL.h SDL_AddEventWatch" addEventWatchFFI :: EventFilter -> Ptr () -> IO ()
foreign import ccall "SDL3/SDL.h SDL_RemoveEventWatch" delEventWatchFFI :: EventFilter -> Ptr () -> IO ()
foreign import ccall "SDL3/SDL.h SDL_EventState" eventStateFFI :: Word32 -> CInt -> IO Word8
foreign import ccall "SDL3/SDL.h SDL_FilterEvents" filterEventsFFI :: EventFilter -> Ptr () -> IO ()
foreign import ccall "SDL3/SDL.h SDL_FlushEvent" flushEventFFI :: Word32 -> IO ()
foreign import ccall "SDL3/SDL.h SDL_FlushEvents" flushEventsFFI :: Word32 -> Word32 -> IO ()
foreign import ccall "SDL3/SDL.h SDL_GetEventFilter" getEventFilterFFI :: Ptr EventFilter -> Ptr (Ptr ()) -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetNumTouchDevices" getNumTouchDevicesFFI :: IO CInt
foreign import ccall "SDL3/SDL.h SDL_GetNumTouchFingers" getNumTouchFingersFFI :: TouchID -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_GetTouchDevice" getTouchDeviceFFI :: CInt -> IO TouchID
foreign import ccall "SDL3/SDL.h SDL_GetTouchFinger" getTouchFingerFFI :: TouchID -> CInt -> IO (Ptr Finger)
foreign import ccall "SDL3/SDL.h SDL_HasEvent" hasEventFFI :: Word32 -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_HasEvents" hasEventsFFI :: Word32 -> Word32 -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_PeepEvents" peepEventsFFI :: Ptr Event -> CInt -> EventAction -> Word32 -> Word32 -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_PollEvent" pollEventFFI :: Ptr Event -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_PumpEvents" pumpEventsFFI :: IO ()
foreign import ccall "SDL3/SDL.h SDL_PushEvent" pushEventFFI :: Ptr Event -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_RecordGesture" recordGestureFFI :: TouchID -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_RegisterEvents" registerEventsFFI :: CInt -> IO Word32
foreign import ccall "SDL3/SDL.h SDL_SetEventFilter" setEventFilterFFI :: EventFilter -> Ptr () -> IO ()
foreign import ccall "SDL3/SDL.h SDL_WaitEvent" waitEventFFI :: Ptr Event -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_WaitEventTimeout" waitEventTimeoutFFI :: Ptr Event -> CInt -> IO CInt

foreign import ccall "SDL3/SDL.h SDL_GetKeyFromName" getKeyFromNameFFI :: CString -> IO Keycode
foreign import ccall "SDL3/SDL.h SDL_GetKeyFromScancode" getKeyFromScancodeFFI :: Scancode -> IO Keycode
foreign import ccall "SDL3/SDL.h SDL_GetKeyName" getKeyNameFFI :: Keycode -> IO CString
foreign import ccall "SDL3/SDL.h SDL_GetKeyboardFocus" getKeyboardFocusFFI :: IO Window
foreign import ccall "SDL3/SDL.h SDL_GetKeyboardState" getKeyboardStateFFI :: Ptr CInt -> IO (Ptr Word8)
foreign import ccall "SDL3/SDL.h SDL_GetModState" getModStateFFI :: IO Keymod
foreign import ccall "SDL3/SDL.h SDL_GetScancodeFromKey" getScancodeFromKeyFFI :: Keycode -> IO Scancode
foreign import ccall "SDL3/SDL.h SDL_GetScancodeFromName" getScancodeFromNameFFI :: CString -> IO Scancode
foreign import ccall "SDL3/SDL.h SDL_GetScancodeName" getScancodeNameFFI :: Scancode -> IO CString
foreign import ccall "SDL3/SDL.h SDL_HasScreenKeyboardSupport" hasScreenKeyboardSupportFFI :: IO Bool
foreign import ccall "SDL3/SDL.h SDL_ScreenKeyboardShown" isScreenKeyboardShownFFI :: Window -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_TextInputActive" isTextInputActiveFFI :: IO Bool
foreign import ccall "SDL3/SDL.h SDL_SetModState" setModStateFFI :: Keymod -> IO ()
foreign import ccall "SDL3/SDL.h SDL_SetTextInputRect" setTextInputRectFFI :: Ptr Rect -> IO ()
foreign import ccall "SDL3/SDL.h SDL_StartTextInput" startTextInputFFI :: IO ()
foreign import ccall "SDL3/SDL.h SDL_StopTextInput" stopTextInputFFI :: IO ()

foreign import ccall "SDL3/SDL.h SDL_CaptureMouse" captureMouseFFI :: Bool -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_CreateColorCursor" createColorCursorFFI :: Ptr Surface -> CInt -> CInt -> IO Cursor
foreign import ccall "SDL3/SDL.h SDL_CreateCursor" createCursorFFI :: Ptr Word8 -> Ptr Word8 -> CInt -> CInt -> CInt -> CInt -> IO Cursor
foreign import ccall "SDL3/SDL.h SDL_CreateSystemCursor" createSystemCursorFFI :: SystemCursor -> IO Cursor
foreign import ccall "SDL3/SDL.h SDL_DestroyCursor" freeCursorFFI :: Cursor -> IO ()
foreign import ccall "SDL3/SDL.h SDL_GetCursor" getCursorFFI :: IO Cursor
foreign import ccall "SDL3/SDL.h SDL_GetDefaultCursor" getDefaultCursorFFI :: IO Cursor
foreign import ccall "SDL3/SDL.h SDL_GetGlobalMouseState" getGlobalMouseStateFFI :: Ptr CInt -> Ptr CInt -> IO Word32
foreign import ccall "SDL3/SDL.h SDL_GetMouseFocus" getMouseFocusFFI :: IO Window
foreign import ccall "SDL3/SDL.h SDL_GetMouseState" getMouseStateFFI :: Ptr CInt -> Ptr CInt -> IO Word32
foreign import ccall "SDL3/SDL.h SDL_GetRelativeMouseMode" getRelativeMouseModeFFI :: IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetRelativeMouseState" getRelativeMouseStateFFI :: Ptr CInt -> Ptr CInt -> IO Word32
foreign import ccall "SDL3/SDL.h SDL_SetCursor" setCursorFFI :: Cursor -> IO ()
foreign import ccall "SDL3/SDL.h SDL_SetRelativeMouseMode" setRelativeMouseModeFFI :: Bool -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_ShowCursor" showCursorFFI :: CInt -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_WarpMouseGlobal" warpMouseGlobalFFI :: CInt -> CInt -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_WarpMouseInWindow" warpMouseInWindowFFI :: Window -> CInt -> CInt -> IO ()
foreign import ccall "SDL3/SDL.h SDL_AddGamepadMapping" gamepadAddMappingFFI :: CString -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_AddGamepadMappingsFromIO" gamepadAddMappingsFromRWFFI :: Ptr IOStream -> CInt -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_CloseGamepad" gamepadCloseFFI :: Gamepad -> IO ()
foreign import ccall "SDL3/SDL.h SDL_GamepadEventState" gamepadEventStateFFI :: CInt -> IO CInt
foreign import ccall "SDL3/SDL.h SDL_GetGamepadFromID" gamepadFromInstanceIDFFI :: JoystickID -> IO Gamepad
foreign import ccall "SDL3/SDL.h SDL_GamepadConnected" gamepadGetAttachedFFI :: Gamepad -> IO Bool
foreign import ccall "SDL3/SDL.h SDL_GetGamepadAxis" gamepadGetAxisFFI :: Gamepad -> GamepadAxis -> IO Int16
foreign import ccall "SDL3/SDL.h SDL_GetGamepadAxisFromString" gamepadGetAxisFromStringFFI :: CString -> IO GamepadAxis
foreign import ccall "sdlhelper.h SDLHelper_GamepadGetBindForAxis" gamepadGetBindForAxisFFI :: Gamepad -> GamepadAxis -> Ptr GamepadBinding -> IO ()
foreign import ccall "sdlhelper.h SDLHelper_GamepadGetBindForButton" gamepadGetBindForButtonFFI :: Gamepad -> GamepadButton -> Ptr GamepadBinding -> IO ()
foreign import ccall "SDL3/SDL.h SDL_GetGamepadButton" gamepadGetButtonFFI :: Gamepad -> GamepadButton -> IO Word8
foreign import ccall "SDL3/SDL.h SDL_GetGamepadButtonFromString" gamepadGetButtonFromStringFFI :: CString -> IO GamepadButton
foreign import ccall "SDL3/SDL.h SDL_GetGamepadJoystick" gamepadGetJoystickFFI :: Gamepad -> IO Joystick
foreign import ccall "SDL3/SDL.h SDL_GetGamepadStringForAxis" gamepadGetStringForAxisFFI :: GamepadAxis -> IO CString
foreign import ccall "SDL3/SDL.h SDL_GetGamepadStringForButton" gamepadGetStringForButtonFFI :: GamepadButton -> IO CString
foreign import ccall "SDL3/SDL.h SDL_GetGamepadMapping" gamepadMappingFFI :: Gamepad -> IO CString
foreign import ccall "sdlhelper.h SDLHelper_GamepadMappingForGUID" gamepadMappingForGUIDFFI :: Ptr JoystickGUID -> IO CString
foreign import ccall "SDL3/SDL.h SDL_GetGamepadName" gamepadNameFFI :: Gamepad -> IO CString
foreign import ccall "SDL3/SDL.h SDL_GamepadNameForIndex" gamepadNameForIndexFFI :: CInt -> IO CString
foreign import ccall "SDL3/SDL.h SDL_OpenGamepad" gamepadOpenFFI :: CInt -> IO Gamepad
foreign import ccall "SDL3/SDL.h SDL_UpdateGamepads" gamepadUpdateFFI :: IO ()
foreign import ccall "SDL3/SDL.h SDL_IsGamepad" isGamepadFFI :: CInt -> IO Bool

foreign import ccall "sdlhelper.c SDLHelper_GetEventBufferSize" eventBufferSize :: CInt
foreign import ccall "sdlhelper.c SDLHelper_GetEventBuffer"  eventBuffer :: Ptr Event

addEventWatch :: MonadIO m => EventFilter -> Ptr () -> m ()
addEventWatch v1 v2 = liftIO $ addEventWatchFFI v1 v2
{-# INLINE addEventWatch #-}

delEventWatch :: MonadIO m => EventFilter -> Ptr () -> m ()
delEventWatch v1 v2 = liftIO $ delEventWatchFFI v1 v2
{-# INLINE delEventWatch #-}

eventState :: MonadIO m => Word32 -> CInt -> m Word8
eventState v1 v2 = liftIO $ eventStateFFI v1 v2
{-# INLINE eventState #-}

filterEvents :: MonadIO m => EventFilter -> Ptr () -> m ()
filterEvents v1 v2 = liftIO $ filterEventsFFI v1 v2
{-# INLINE filterEvents #-}

flushEvent :: MonadIO m => Word32 -> m ()
flushEvent v1 = liftIO $ flushEventFFI v1
{-# INLINE flushEvent #-}

flushEvents :: MonadIO m => Word32 -> Word32 -> m ()
flushEvents v1 v2 = liftIO $ flushEventsFFI v1 v2
{-# INLINE flushEvents #-}

getEventFilter :: MonadIO m => Ptr EventFilter -> Ptr (Ptr ()) -> m Bool
getEventFilter v1 v2 = liftIO $ getEventFilterFFI v1 v2
{-# INLINE getEventFilter #-}

getNumTouchDevices :: MonadIO m => m CInt
getNumTouchDevices = liftIO getNumTouchDevicesFFI
{-# INLINE getNumTouchDevices #-}

getNumTouchFingers :: MonadIO m => TouchID -> m CInt
getNumTouchFingers v1 = liftIO $ getNumTouchFingersFFI v1
{-# INLINE getNumTouchFingers #-}

getTouchDevice :: MonadIO m => CInt -> m TouchID
getTouchDevice v1 = liftIO $ getTouchDeviceFFI v1
{-# INLINE getTouchDevice #-}

getTouchFinger :: MonadIO m => TouchID -> CInt -> m (Ptr Finger)
getTouchFinger v1 v2 = liftIO $ getTouchFingerFFI v1 v2
{-# INLINE getTouchFinger #-}

hasEvent :: MonadIO m => Word32 -> m Bool
hasEvent v1 = liftIO $ hasEventFFI v1
{-# INLINE hasEvent #-}

hasEvents :: MonadIO m => Word32 -> Word32 -> m Bool
hasEvents v1 v2 = liftIO $ hasEventsFFI v1 v2
{-# INLINE hasEvents #-}

peepEvents :: MonadIO m => Ptr Event -> CInt -> EventAction -> Word32 -> Word32 -> m CInt
peepEvents v1 v2 v3 v4 v5 = liftIO $ peepEventsFFI v1 v2 v3 v4 v5
{-# INLINE peepEvents #-}

pollEvent :: MonadIO m => Ptr Event -> m CInt
pollEvent v1 = liftIO $ pollEventFFI v1
{-# INLINE pollEvent #-}

pumpEvents :: MonadIO m => m ()
pumpEvents = liftIO pumpEventsFFI
{-# INLINE pumpEvents #-}

pushEvent :: MonadIO m => Ptr Event -> m CInt
pushEvent v1 = liftIO $ pushEventFFI v1
{-# INLINE pushEvent #-}

quitRequested :: MonadIO m => m Bool
quitRequested = liftIO $ do
  pumpEvents
  ev <- peepEvents nullPtr 0 SDL_PEEKEVENT SDL_EVENT_QUIT SDL_EVENT_QUIT
  return $ ev > 0
{-# INLINE quitRequested #-}

recordGesture :: MonadIO m => TouchID -> m CInt
recordGesture v1 = liftIO $ recordGestureFFI v1
{-# INLINE recordGesture #-}

registerEvents :: MonadIO m => CInt -> m Word32
registerEvents v1 = liftIO $ registerEventsFFI v1
{-# INLINE registerEvents #-}

setEventFilter :: MonadIO m => EventFilter -> Ptr () -> m ()
setEventFilter v1 v2 = liftIO $ setEventFilterFFI v1 v2
{-# INLINE setEventFilter #-}

waitEventTimeout :: MonadIO m => Ptr Event -> CInt -> m CInt
waitEventTimeout v1 v2 = liftIO $ waitEventTimeoutFFI v1 v2
{-# INLINE waitEventTimeout #-}

getKeyFromName :: MonadIO m => CString -> m Keycode
getKeyFromName v1 = liftIO $ getKeyFromNameFFI v1
{-# INLINE getKeyFromName #-}

getKeyFromScancode :: MonadIO m => Scancode -> m Keycode
getKeyFromScancode v1 = liftIO $ getKeyFromScancodeFFI v1
{-# INLINE getKeyFromScancode #-}

getKeyName :: MonadIO m => Keycode -> m CString
getKeyName v1 = liftIO $ getKeyNameFFI v1
{-# INLINE getKeyName #-}

getKeyboardFocus :: MonadIO m => m Window
getKeyboardFocus = liftIO getKeyboardFocusFFI
{-# INLINE getKeyboardFocus #-}

getKeyboardState :: MonadIO m => Ptr CInt -> m (Ptr Word8)
getKeyboardState v1 = liftIO $ getKeyboardStateFFI v1
{-# INLINE getKeyboardState #-}

getModState :: MonadIO m => m Keymod
getModState = liftIO getModStateFFI
{-# INLINE getModState #-}

getScancodeFromKey :: MonadIO m => Keycode -> m Scancode
getScancodeFromKey v1 = liftIO $ getScancodeFromKeyFFI v1
{-# INLINE getScancodeFromKey #-}

getScancodeFromName :: MonadIO m => CString -> m Scancode
getScancodeFromName v1 = liftIO $ getScancodeFromNameFFI v1
{-# INLINE getScancodeFromName #-}

getScancodeName :: MonadIO m => Scancode -> m CString
getScancodeName v1 = liftIO $ getScancodeNameFFI v1
{-# INLINE getScancodeName #-}

hasScreenKeyboardSupport :: MonadIO m => m Bool
hasScreenKeyboardSupport = liftIO hasScreenKeyboardSupportFFI
{-# INLINE hasScreenKeyboardSupport #-}

isScreenKeyboardShown :: MonadIO m => Window -> m Bool
isScreenKeyboardShown v1 = liftIO $ isScreenKeyboardShownFFI v1
{-# INLINE isScreenKeyboardShown #-}

isTextInputActive :: MonadIO m => m Bool
isTextInputActive = liftIO isTextInputActiveFFI
{-# INLINE isTextInputActive #-}

setModState :: MonadIO m => Keymod -> m ()
setModState v1 = liftIO $ setModStateFFI v1
{-# INLINE setModState #-}

setTextInputRect :: MonadIO m => Ptr Rect -> m ()
setTextInputRect v1 = liftIO $ setTextInputRectFFI v1
{-# INLINE setTextInputRect #-}

startTextInput :: MonadIO m => m ()
startTextInput = liftIO startTextInputFFI
{-# INLINE startTextInput #-}

stopTextInput :: MonadIO m => m ()
stopTextInput = liftIO stopTextInputFFI
{-# INLINE stopTextInput #-}

captureMouse :: MonadIO m => Bool -> m CInt
captureMouse v1 = liftIO $ captureMouseFFI v1
{-# INLINE captureMouse #-}

createColorCursor :: MonadIO m => Ptr Surface -> CInt -> CInt -> m Cursor
createColorCursor v1 v2 v3 = liftIO $ createColorCursorFFI v1 v2 v3
{-# INLINE createColorCursor #-}

createCursor :: MonadIO m => Ptr Word8 -> Ptr Word8 -> CInt -> CInt -> CInt -> CInt -> m Cursor
createCursor v1 v2 v3 v4 v5 v6 = liftIO $ createCursorFFI v1 v2 v3 v4 v5 v6
{-# INLINE createCursor #-}

createSystemCursor :: MonadIO m => SystemCursor -> m Cursor
createSystemCursor v1 = liftIO $ createSystemCursorFFI v1
{-# INLINE createSystemCursor #-}

freeCursor :: MonadIO m => Cursor -> m ()
freeCursor v1 = liftIO $ freeCursorFFI v1
{-# INLINE freeCursor #-}

getCursor :: MonadIO m => m Cursor
getCursor = liftIO getCursorFFI
{-# INLINE getCursor #-}

getDefaultCursor :: MonadIO m => m Cursor
getDefaultCursor = liftIO getDefaultCursorFFI
{-# INLINE getDefaultCursor #-}

getGlobalMouseState :: MonadIO m => Ptr CInt -> Ptr CInt -> m Word32
getGlobalMouseState v1 v2 = liftIO $ getGlobalMouseStateFFI v1 v2
{-# INLINE getGlobalMouseState #-}

getMouseFocus :: MonadIO m => m Window
getMouseFocus = liftIO getMouseFocusFFI
{-# INLINE getMouseFocus #-}

getMouseState :: MonadIO m => Ptr CInt -> Ptr CInt -> m Word32
getMouseState v1 v2 = liftIO $ getMouseStateFFI v1 v2
{-# INLINE getMouseState #-}

getRelativeMouseMode :: MonadIO m => m Bool
getRelativeMouseMode = liftIO getRelativeMouseModeFFI
{-# INLINE getRelativeMouseMode #-}

getRelativeMouseState :: MonadIO m => Ptr CInt -> Ptr CInt -> m Word32
getRelativeMouseState v1 v2 = liftIO $ getRelativeMouseStateFFI v1 v2
{-# INLINE getRelativeMouseState #-}

setCursor :: MonadIO m => Cursor -> m ()
setCursor v1 = liftIO $ setCursorFFI v1
{-# INLINE setCursor #-}

setRelativeMouseMode :: MonadIO m => Bool -> m CInt
setRelativeMouseMode v1 = liftIO $ setRelativeMouseModeFFI v1
{-# INLINE setRelativeMouseMode #-}

showCursor :: MonadIO m => CInt -> m CInt
showCursor v1 = liftIO $ showCursorFFI v1
{-# INLINE showCursor #-}

warpMouseGlobal :: MonadIO m => CInt -> CInt -> m CInt
warpMouseGlobal v1 v2 = liftIO $ warpMouseGlobalFFI v1 v2
{-# INLINE warpMouseGlobal #-}

warpMouseInWindow :: MonadIO m => Window -> CInt -> CInt -> m ()
warpMouseInWindow v1 v2 v3 = liftIO $ warpMouseInWindowFFI v1 v2 v3
{-# INLINE warpMouseInWindow #-}

gamepadAddMapping :: MonadIO m => CString -> m CInt
gamepadAddMapping v1 = liftIO $ gamepadAddMappingFFI v1
{-# INLINE gamepadAddMapping #-}

gamepadAddMappingsFromFile :: MonadIO m => CString -> m CInt
gamepadAddMappingsFromFile file = liftIO $ do
  rw <- withCString "rb" $ ioFromFile file
  gamepadAddMappingsFromRW rw 1
{-# INLINE gamepadAddMappingsFromFile #-}

gamepadAddMappingsFromRW :: MonadIO m => Ptr IOStream -> CInt -> m CInt
gamepadAddMappingsFromRW v1 v2 = liftIO $ gamepadAddMappingsFromRWFFI v1 v2
{-# INLINE gamepadAddMappingsFromRW #-}

gamepadClose :: MonadIO m => Gamepad -> m ()
gamepadClose v1 = liftIO $ gamepadCloseFFI v1
{-# INLINE gamepadClose #-}

gamepadEventState :: MonadIO m => CInt -> m CInt
gamepadEventState v1 = liftIO $ gamepadEventStateFFI v1
{-# INLINE gamepadEventState #-}

gamepadFromInstanceID :: MonadIO m => JoystickID -> m Gamepad
gamepadFromInstanceID v1 = liftIO $ gamepadFromInstanceIDFFI v1
{-# INLINE gamepadFromInstanceID #-}

gamepadGetAttached :: MonadIO m => Gamepad -> m Bool
gamepadGetAttached v1 = liftIO $ gamepadGetAttachedFFI v1
{-# INLINE gamepadGetAttached #-}

gamepadGetAxis :: MonadIO m => Gamepad -> GamepadAxis -> m Int16
gamepadGetAxis v1 v2 = liftIO $ gamepadGetAxisFFI v1 v2
{-# INLINE gamepadGetAxis #-}

gamepadGetAxisFromString :: MonadIO m => CString -> m GamepadAxis
gamepadGetAxisFromString v1 = liftIO $ gamepadGetAxisFromStringFFI v1
{-# INLINE gamepadGetAxisFromString #-}

gamepadGetBindForAxis :: MonadIO m => Gamepad -> GamepadAxis -> m GamepadBinding
gamepadGetBindForAxis gamecontroller axis = liftIO . alloca $ \ptr -> do
  gamepadGetBindForAxisFFI gamecontroller axis ptr
  peek ptr
{-# INLINE gamepadGetBindForAxis #-}

gamepadGetBindForButton :: MonadIO m => Gamepad -> GamepadButton -> m GamepadBinding
gamepadGetBindForButton gamecontroller button = liftIO . alloca $ \ptr -> do
  gamepadGetBindForButtonFFI gamecontroller button ptr
  peek ptr
{-# INLINE gamepadGetBindForButton #-}

gamepadGetButton :: MonadIO m => Gamepad -> GamepadButton -> m Word8
gamepadGetButton v1 v2 = liftIO $ gamepadGetButtonFFI v1 v2
{-# INLINE gamepadGetButton #-}

gamepadGetButtonFromString :: MonadIO m => CString -> m GamepadButton
gamepadGetButtonFromString v1 = liftIO $ gamepadGetButtonFromStringFFI v1
{-# INLINE gamepadGetButtonFromString #-}

gamepadGetJoystick :: MonadIO m => Gamepad -> m Joystick
gamepadGetJoystick v1 = liftIO $ gamepadGetJoystickFFI v1
{-# INLINE gamepadGetJoystick #-}

gamepadGetStringForAxis :: MonadIO m => GamepadAxis -> m CString
gamepadGetStringForAxis v1 = liftIO $ gamepadGetStringForAxisFFI v1
{-# INLINE gamepadGetStringForAxis #-}

gamepadGetStringForButton :: MonadIO m => GamepadButton -> m CString
gamepadGetStringForButton v1 = liftIO $ gamepadGetStringForButtonFFI v1
{-# INLINE gamepadGetStringForButton #-}

gamepadMapping :: MonadIO m => Gamepad -> m CString
gamepadMapping v1 = liftIO $ gamepadMappingFFI v1
{-# INLINE gamepadMapping #-}

gamepadMappingForGUID :: MonadIO m => JoystickGUID -> m CString
gamepadMappingForGUID guid = liftIO . alloca $ \ptr -> do
  poke ptr guid
  gamepadMappingForGUIDFFI ptr
{-# INLINE gamepadMappingForGUID #-}

gamepadName :: MonadIO m => Gamepad -> m CString
gamepadName v1 = liftIO $ gamepadNameFFI v1
{-# INLINE gamepadName #-}

gamepadNameForIndex :: MonadIO m => CInt -> m CString
gamepadNameForIndex v1 = liftIO $ gamepadNameForIndexFFI v1
{-# INLINE gamepadNameForIndex #-}

gamepadOpen :: MonadIO m => CInt -> m Gamepad
gamepadOpen v1 = liftIO $ gamepadOpenFFI v1
{-# INLINE gamepadOpen #-}

gamepadUpdate :: MonadIO m => m ()
gamepadUpdate = liftIO gamepadUpdateFFI
{-# INLINE gamepadUpdate #-}

isGamepad :: MonadIO m => CInt -> m Bool
isGamepad v1 = liftIO $ isGamepadFFI v1
{-# INLINE isGamepad #-}
