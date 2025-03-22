{-# LANGUAGE ForeignFunctionInterface #-}

module SDL.Raw.Gamepad
  ( -- Basic gamepad management
    hasGamepad
  , getGamepads
  , isGamepad
  , openGamepad
  , getGamepadFromID
  , getGamepadFromPlayerIndex
  , closeGamepad
  , finalizeGamepad
  , gamepadConnected

  , -- Gamepad properties
    getGamepadNameForID
  , getGamepadPathForID
  , getGamepadPlayerIndexForID
  , getGamepadGUIDForID
  , getGamepadVendorForID
  , getGamepadProductForID
  , getGamepadProductVersionForID
  , getGamepadTypeForID
  , getGamepadRealTypeForID
  , getGamepadMappingForID
  , getGamepadID
  , getGamepadName
  , getGamepadPath
  , getGamepadPlayerIndex
  , setGamepadPlayerIndex
  , getGamepadGUID
  , getGamepadVendor
  , getGamepadProduct
  , getGamepadProductVersion
  , getGamepadFirmwareVersion
  , getGamepadSerial
  , getGamepadSteamHandle
  , getGamepadType
  , getGamepadRealType
  , getGamepadProperties
  , getGamepadJoystick

  , -- Gamepad state
    gamepadHasAxis
  , getGamepadAxis
  , gamepadHasButton
  , getGamepadButton
  , getGamepadButtonLabel
  , getGamepadButtonLabelForType
  , getNumGamepadTouchpads
  , getNumGamepadTouchpadFingers
  , getGamepadTouchpadFinger

  , -- Event handling
    setGamepadEventsEnabled
  , gamepadEventsEnabled
  , updateGamepads

  , -- Rumble and LED
    rumbleGamepad
  , rumbleGamepadTriggers
  , setGamepadLED
  , sendGamepadEffect

  , -- Connection and power
    getGamepadConnectionState
  , getGamepadPowerInfo

  , -- Sensors
    gamepadHasSensor
  , setGamepadSensorEnabled
  , gamepadSensorEnabled
  , getGamepadSensorDataRate
  , getGamepadSensorData

  , -- Mapping
    addGamepadMapping
  , addGamepadMappingsFromFile
  , reloadGamepadMappings
  , getGamepadMappings
  , getGamepadMappingForGUID
  , getGamepadMapping
  , setGamepadMapping
  , getGamepadBindings

  , -- Conversion helpers
    getGamepadTypeFromString
  , getGamepadStringForType
  , getGamepadAxisFromString
  , getGamepadStringForAxis
  , getGamepadButtonFromString
  , getGamepadStringForButton

  , -- Apple-specific
    getGamepadAppleSFSymbolsNameForButton
  , getGamepadAppleSFSymbolsNameForAxis

  , -- Helper functions for GUID
    gamepadGetGUIDForID
  , gamepadGetGUID
  , gamepadGetGUIDFromString
  , gamepadGetGUIDString
  ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Int (Int16, Int32)
import Data.Word (Word8, Word16, Word32, Word64)
import Foreign.C.Types (CInt(..), CFloat(..), CBool(..))
import Foreign.C.String (CString)
import Foreign.Ptr (Ptr, FunPtr, castPtr)
import Foreign.Marshal.Alloc
import Foreign.Marshal.Utils
import Foreign.Storable (peek)
import SDL.Raw.Types (Gamepad, GamepadBinding, Joystick, JoystickID, GUID, IOStream, PropertiesID)
import SDL.Raw.Enum (GamepadType, GamepadAxis(..), GamepadButton(..), GamepadButtonLabel, JoystickConnectionState, PowerState, SensorType)

-- Basic gamepad management
foreign import ccall "SDL3/SDL_gamepad.h SDL_HasGamepad" hasGamepadFFI :: IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepads" getGamepadsFFI :: Ptr CInt -> IO (Ptr JoystickID)
foreign import ccall "SDL3/SDL_gamepad.h SDL_IsGamepad" isGamepadFFI :: JoystickID -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_OpenGamepad" openGamepadFFI :: JoystickID -> IO Gamepad
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadFromID" getGamepadFromIDFFI :: JoystickID -> IO Gamepad
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadFromPlayerIndex" getGamepadFromPlayerIndexFFI :: CInt -> IO Gamepad
foreign import ccall "SDL3/SDL_gamepad.h SDL_CloseGamepad" closeGamepadFFI :: Ptr () -> IO ()
foreign import ccall "SDL3/SDL_gamepad.h SDL_GamepadConnected" gamepadConnectedFFI :: Ptr () -> IO CBool

-- Gamepad properties
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadNameForID" getGamepadNameForIDFFI :: JoystickID -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadPathForID" getGamepadPathForIDFFI :: JoystickID -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadPlayerIndexForID" getGamepadPlayerIndexForIDFFI :: JoystickID -> IO CInt
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadGUIDForID" getGamepadGUIDForIDFFI :: JoystickID -> IO (Ptr GUID)
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadVendorForID" getGamepadVendorForIDFFI :: JoystickID -> IO Word16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadProductForID" getGamepadProductForIDFFI :: JoystickID -> IO Word16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadProductVersionForID" getGamepadProductVersionForIDFFI :: JoystickID -> IO Word16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadTypeForID" getGamepadTypeForIDFFI :: JoystickID -> IO GamepadType
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetRealGamepadTypeForID" getGamepadRealTypeForIDFFI :: JoystickID -> IO GamepadType
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadMappingForID" getGamepadMappingForIDFFI :: JoystickID -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadID" getGamepadIDFFI :: Ptr () -> IO JoystickID
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadName" getGamepadNameFFI :: Ptr () -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadPath" getGamepadPathFFI :: Ptr () -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadPlayerIndex" getGamepadPlayerIndexFFI :: Ptr () -> IO CInt
foreign import ccall "SDL3/SDL_gamepad.h SDL_SetGamepadPlayerIndex" setGamepadPlayerIndexFFI :: Ptr () -> CInt -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadGUID" getGamepadGUIDFFI :: Ptr () -> IO (Ptr GUID)
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadVendor" getGamepadVendorFFI :: Ptr () -> IO Word16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadProduct" getGamepadProductFFI :: Ptr () -> IO Word16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadProductVersion" getGamepadProductVersionFFI :: Ptr () -> IO Word16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadFirmwareVersion" getGamepadFirmwareVersionFFI :: Ptr () -> IO Word16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadSerial" getGamepadSerialFFI :: Ptr () -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadSteamHandle" getGamepadSteamHandleFFI :: Ptr () -> IO Word64
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadType" getGamepadTypeFFI :: Ptr () -> IO GamepadType
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetRealGamepadType" getGamepadRealTypeFFI :: Ptr () -> IO GamepadType
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadProperties" getGamepadPropertiesFFI :: Ptr () -> IO PropertiesID
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadJoystick" getGamepadJoystickFFI :: Ptr () -> IO Joystick

-- Gamepad state
foreign import ccall "SDL3/SDL_gamepad.h SDL_GamepadHasAxis" gamepadHasAxisFFI :: Ptr () -> GamepadAxis -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadAxis" getGamepadAxisFFI :: Ptr () -> GamepadAxis -> IO Int16
foreign import ccall "SDL3/SDL_gamepad.h SDL_GamepadHasButton" gamepadHasButtonFFI :: Ptr () -> GamepadButton -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadButton" getGamepadButtonFFI :: Ptr () -> GamepadButton -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadButtonLabel" getGamepadButtonLabelFFI :: Ptr () -> GamepadButton -> IO GamepadButtonLabel
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadButtonLabelForType" getGamepadButtonLabelForTypeFFI :: GamepadType -> GamepadButton -> IO GamepadButtonLabel
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetNumGamepadTouchpads" getNumGamepadTouchpadsFFI :: Ptr () -> IO CInt
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetNumGamepadTouchpadFingers" getNumGamepadTouchpadFingersFFI :: Ptr () -> CInt -> IO CInt
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadTouchpadFinger" getGamepadTouchpadFingerFFI :: Ptr () -> CInt -> CInt -> Ptr CBool -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> IO CBool

-- Event handling
foreign import ccall "SDL3/SDL_gamepad.h SDL_SetGamepadEventsEnabled" setGamepadEventsEnabledFFI :: CBool -> IO ()
foreign import ccall "SDL3/SDL_gamepad.h SDL_GamepadEventsEnabled" gamepadEventsEnabledFFI :: IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_UpdateGamepads" updateGamepadsFFI :: IO ()

-- Rumble and LED
foreign import ccall "SDL3/SDL_gamepad.h SDL_RumbleGamepad" rumbleGamepadFFI :: Ptr () -> Word16 -> Word16 -> Word32 -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_RumbleGamepadTriggers" rumbleGamepadTriggersFFI :: Ptr () -> Word16 -> Word16 -> Word32 -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_SetGamepadLED" setGamepadLEDFFI :: Ptr () -> Word8 -> Word8 -> Word8 -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_SendGamepadEffect" sendGamepadEffectFFI :: Ptr () -> Ptr () -> CInt -> IO CBool

-- Connection and power
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadConnectionState" getGamepadConnectionStateFFI :: Ptr () -> IO JoystickConnectionState
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadPowerInfo" getGamepadPowerInfoFFI :: Ptr () -> Ptr CInt -> IO PowerState

-- Sensors
foreign import ccall "SDL3/SDL_gamepad.h SDL_GamepadHasSensor" gamepadHasSensorFFI :: Ptr () -> SensorType -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_SetGamepadSensorEnabled" setGamepadSensorEnabledFFI :: Ptr () -> SensorType -> CBool -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GamepadSensorEnabled" gamepadSensorEnabledFFI :: Ptr () -> SensorType -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadSensorDataRate" getGamepadSensorDataRateFFI :: Ptr () -> SensorType -> IO CFloat
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadSensorData" getGamepadSensorDataFFI :: Ptr () -> SensorType -> Ptr CFloat -> CInt -> IO CBool

-- Mapping
foreign import ccall "SDL3/SDL_gamepad.h SDL_AddGamepadMapping" addGamepadMappingFFI :: CString -> IO CInt
foreign import ccall "SDL3/SDL_gamepad.h SDL_AddGamepadMappingsFromFile" addGamepadMappingsFromFileFFI :: CString -> IO CInt
foreign import ccall "SDL3/SDL_gamepad.h SDL_ReloadGamepadMappings" reloadGamepadMappingsFFI :: IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadMappings" getGamepadMappingsFFI :: Ptr CInt -> IO (Ptr CString)
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadMappingForGUID" getGamepadMappingForGUIDFFI :: Ptr GUID -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadMapping" getGamepadMappingFFI :: Ptr () -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_SetGamepadMapping" setGamepadMappingFFI :: JoystickID -> CString -> IO CBool
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadBindings" getGamepadBindingsFFI :: Ptr () -> Ptr CInt -> IO (Ptr (Ptr SDL.Raw.Types.GamepadBinding))

-- Conversion helpers
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadTypeFromString" getGamepadTypeFromStringFFI :: CString -> IO GamepadType
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadStringForType" getGamepadStringForTypeFFI :: GamepadType -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadAxisFromString" getGamepadAxisFromStringFFI :: CString -> IO GamepadAxis
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadStringForAxis" getGamepadStringForAxisFFI :: GamepadAxis -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadButtonFromString" getGamepadButtonFromStringFFI :: CString -> IO GamepadButton
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadStringForButton" getGamepadStringForButtonFFI :: GamepadButton -> IO CString

-- Apple-specific
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadAppleSFSymbolsNameForButton" getGamepadAppleSFSymbolsNameForButtonFFI :: Ptr () -> GamepadButton -> IO CString
foreign import ccall "SDL3/SDL_gamepad.h SDL_GetGamepadAppleSFSymbolsNameForAxis" getGamepadAppleSFSymbolsNameForAxisFFI :: Ptr () -> GamepadAxis -> IO CString

-- Helper functions from sdlhelper.c (assuming similar helpers exist or will be added)
foreign import ccall "sdlhelper.h SDLHelper_GamepadGetGUIDForID" gamepadGetGUIDForIDFFI :: JoystickID -> Ptr GUID -> IO ()
foreign import ccall "sdlhelper.h SDLHelper_GamepadGetGUID" gamepadGetGUIDFFI :: Ptr () -> Ptr GUID -> IO ()
foreign import ccall "sdlhelper.h SDLHelper_GamepadGetGUIDFromString" gamepadGetGUIDFromStringFFI :: CString -> Ptr GUID -> IO ()
foreign import ccall "sdlhelper.h SDLHelper_GamepadGetGUIDString" gamepadGetGUIDStringFFI :: Ptr GUID -> CString -> CInt -> IO ()

-- Finalizer: This is used by the higher level API for GC
foreign import ccall unsafe "&SDL_CloseGamepad" finalizeGamepad :: FunPtr (Ptr () -> IO ())

-- Wrapper functions
hasGamepad :: MonadIO m => m CBool
hasGamepad = liftIO hasGamepadFFI
{-# INLINE hasGamepad #-}

getGamepads :: MonadIO m => Ptr CInt -> m (Ptr JoystickID)
getGamepads count = liftIO $ getGamepadsFFI count
{-# INLINE getGamepads #-}

isGamepad :: MonadIO m => JoystickID -> m CBool
isGamepad instanceId = liftIO $ isGamepadFFI instanceId
{-# INLINE isGamepad #-}

openGamepad :: MonadIO m => JoystickID -> m Gamepad
openGamepad instanceId = liftIO $ openGamepadFFI instanceId
{-# INLINE openGamepad #-}

getGamepadFromID :: MonadIO m => JoystickID -> m Gamepad
getGamepadFromID instanceId = liftIO $ getGamepadFromIDFFI instanceId
{-# INLINE getGamepadFromID #-}

getGamepadFromPlayerIndex :: MonadIO m => CInt -> m Gamepad
getGamepadFromPlayerIndex playerIndex = liftIO $ getGamepadFromPlayerIndexFFI playerIndex
{-# INLINE getGamepadFromPlayerIndex #-}

closeGamepad :: MonadIO m => Gamepad -> m ()
closeGamepad gamepad = liftIO $ closeGamepadFFI gamepad
{-# INLINE closeGamepad #-}

gamepadConnected :: MonadIO m => Gamepad -> m CBool
gamepadConnected gamepad = liftIO $ gamepadConnectedFFI gamepad
{-# INLINE gamepadConnected #-}

getGamepadNameForID :: MonadIO m => JoystickID -> m CString
getGamepadNameForID instanceId = liftIO $ getGamepadNameForIDFFI instanceId
{-# INLINE getGamepadNameForID #-}

getGamepadPathForID :: MonadIO m => JoystickID -> m CString
getGamepadPathForID instanceId = liftIO $ getGamepadPathForIDFFI instanceId
{-# INLINE getGamepadPathForID #-}

getGamepadPlayerIndexForID :: MonadIO m => JoystickID -> m CInt
getGamepadPlayerIndexForID instanceId = liftIO $ getGamepadPlayerIndexForIDFFI instanceId
{-# INLINE getGamepadPlayerIndexForID #-}

getGamepadGUIDForID :: MonadIO m => JoystickID -> m (Ptr GUID)
getGamepadGUIDForID instanceId = liftIO $ getGamepadGUIDForIDFFI instanceId
{-# INLINE getGamepadGUIDForID #-}

getGamepadVendorForID :: MonadIO m => JoystickID -> m Word16
getGamepadVendorForID instanceId = liftIO $ getGamepadVendorForIDFFI instanceId
{-# INLINE getGamepadVendorForID #-}

getGamepadProductForID :: MonadIO m => JoystickID -> m Word16
getGamepadProductForID instanceId = liftIO $ getGamepadProductForIDFFI instanceId
{-# INLINE getGamepadProductForID #-}

getGamepadProductVersionForID :: MonadIO m => JoystickID -> m Word16
getGamepadProductVersionForID instanceId = liftIO $ getGamepadProductVersionForIDFFI instanceId
{-# INLINE getGamepadProductVersionForID #-}

getGamepadTypeForID :: MonadIO m => JoystickID -> m GamepadType
getGamepadTypeForID instanceId = liftIO $ getGamepadTypeForIDFFI instanceId
{-# INLINE getGamepadTypeForID #-}

getGamepadRealTypeForID :: MonadIO m => JoystickID -> m GamepadType
getGamepadRealTypeForID instanceId = liftIO $ getGamepadRealTypeForIDFFI instanceId
{-# INLINE getGamepadRealTypeForID #-}

getGamepadMappingForID :: MonadIO m => JoystickID -> m CString
getGamepadMappingForID instanceId = liftIO $ getGamepadMappingForIDFFI instanceId
{-# INLINE getGamepadMappingForID #-}

getGamepadID :: MonadIO m => Gamepad -> m JoystickID
getGamepadID gamepad = liftIO $ getGamepadIDFFI gamepad
{-# INLINE getGamepadID #-}

getGamepadName :: MonadIO m => Gamepad -> m CString
getGamepadName gamepad = liftIO $ getGamepadNameFFI gamepad
{-# INLINE getGamepadName #-}

getGamepadPath :: MonadIO m => Gamepad -> m CString
getGamepadPath gamepad = liftIO $ getGamepadPathFFI gamepad
{-# INLINE getGamepadPath #-}

getGamepadPlayerIndex :: MonadIO m => Gamepad -> m CInt
getGamepadPlayerIndex gamepad = liftIO $ getGamepadPlayerIndexFFI gamepad
{-# INLINE getGamepadPlayerIndex #-}

setGamepadPlayerIndex :: MonadIO m => Gamepad -> CInt -> m CBool
setGamepadPlayerIndex gamepad playerIndex = liftIO $ setGamepadPlayerIndexFFI gamepad playerIndex
{-# INLINE setGamepadPlayerIndex #-}

getGamepadGUID :: MonadIO m => Gamepad -> m (Ptr GUID)
getGamepadGUID gamepad = liftIO $ getGamepadGUIDFFI gamepad
{-# INLINE getGamepadGUID #-}

getGamepadVendor :: MonadIO m => Gamepad -> m Word16
getGamepadVendor gamepad = liftIO $ getGamepadVendorFFI gamepad
{-# INLINE getGamepadVendor #-}

getGamepadProduct :: MonadIO m => Gamepad -> m Word16
getGamepadProduct gamepad = liftIO $ getGamepadProductFFI gamepad
{-# INLINE getGamepadProduct #-}

getGamepadProductVersion :: MonadIO m => Gamepad -> m Word16
getGamepadProductVersion gamepad = liftIO $ getGamepadProductVersionFFI gamepad
{-# INLINE getGamepadProductVersion #-}

getGamepadFirmwareVersion :: MonadIO m => Gamepad -> m Word16
getGamepadFirmwareVersion gamepad = liftIO $ getGamepadFirmwareVersionFFI gamepad
{-# INLINE getGamepadFirmwareVersion #-}

getGamepadSerial :: MonadIO m => Gamepad -> m CString
getGamepadSerial gamepad = liftIO $ getGamepadSerialFFI gamepad
{-# INLINE getGamepadSerial #-}

getGamepadSteamHandle :: MonadIO m => Gamepad -> m Word64
getGamepadSteamHandle gamepad = liftIO $ getGamepadSteamHandleFFI gamepad
{-# INLINE getGamepadSteamHandle #-}

getGamepadType :: MonadIO m => Gamepad -> m GamepadType
getGamepadType gamepad = liftIO $ getGamepadTypeFFI gamepad
{-# INLINE getGamepadType #-}

getGamepadRealType :: MonadIO m => Gamepad -> m GamepadType
getGamepadRealType gamepad = liftIO $ getGamepadRealTypeFFI gamepad
{-# INLINE getGamepadRealType #-}

getGamepadProperties :: MonadIO m => Gamepad -> m PropertiesID
getGamepadProperties gamepad = liftIO $ getGamepadPropertiesFFI gamepad
{-# INLINE getGamepadProperties #-}

getGamepadJoystick :: MonadIO m => Gamepad -> m Joystick
getGamepadJoystick gamepad = liftIO $ getGamepadJoystickFFI gamepad
{-# INLINE getGamepadJoystick #-}

gamepadHasAxis :: MonadIO m => Gamepad -> GamepadAxis -> m CBool
gamepadHasAxis gamepad axis = liftIO $ gamepadHasAxisFFI gamepad axis
{-# INLINE gamepadHasAxis #-}

getGamepadAxis :: MonadIO m => Gamepad -> GamepadAxis -> m Int16
getGamepadAxis gamepad axis = liftIO $ getGamepadAxisFFI gamepad axis
{-# INLINE getGamepadAxis #-}

gamepadHasButton :: MonadIO m => Gamepad -> GamepadButton -> m CBool
gamepadHasButton gamepad button = liftIO $ gamepadHasButtonFFI gamepad button
{-# INLINE gamepadHasButton #-}

getGamepadButton :: MonadIO m => Gamepad -> GamepadButton -> m CBool
getGamepadButton gamepad button = liftIO $ getGamepadButtonFFI gamepad button
{-# INLINE getGamepadButton #-}

getGamepadButtonLabel :: MonadIO m => Gamepad -> GamepadButton -> m GamepadButtonLabel
getGamepadButtonLabel gamepad button = liftIO $ getGamepadButtonLabelFFI gamepad button
{-# INLINE getGamepadButtonLabel #-}

getGamepadButtonLabelForType :: MonadIO m => GamepadType -> GamepadButton -> m GamepadButtonLabel
getGamepadButtonLabelForType gtype button = liftIO $ getGamepadButtonLabelForTypeFFI gtype button
{-# INLINE getGamepadButtonLabelForType #-}

getNumGamepadTouchpads :: MonadIO m => Gamepad -> m CInt
getNumGamepadTouchpads gamepad = liftIO $ getNumGamepadTouchpadsFFI gamepad
{-# INLINE getNumGamepadTouchpads #-}

getNumGamepadTouchpadFingers :: MonadIO m => Gamepad -> CInt -> m CInt
getNumGamepadTouchpadFingers gamepad touchpad = liftIO $ getNumGamepadTouchpadFingersFFI gamepad touchpad
{-# INLINE getNumGamepadTouchpadFingers #-}

getGamepadTouchpadFinger :: MonadIO m => Gamepad -> CInt -> CInt -> Ptr CBool -> Ptr CFloat -> Ptr CFloat -> Ptr CFloat -> m CBool
getGamepadTouchpadFinger gamepad touchpad finger down x y pressure = liftIO $ getGamepadTouchpadFingerFFI gamepad touchpad finger down x y pressure
{-# INLINE getGamepadTouchpadFinger #-}

setGamepadEventsEnabled :: MonadIO m => CBool -> m ()
setGamepadEventsEnabled enabled = liftIO $ setGamepadEventsEnabledFFI enabled
{-# INLINE setGamepadEventsEnabled #-}

gamepadEventsEnabled :: MonadIO m => m CBool
gamepadEventsEnabled = liftIO gamepadEventsEnabledFFI
{-# INLINE gamepadEventsEnabled #-}

updateGamepads :: MonadIO m => m ()
updateGamepads = liftIO updateGamepadsFFI
{-# INLINE updateGamepads #-}

rumbleGamepad :: MonadIO m => Gamepad -> Word16 -> Word16 -> Word32 -> m CBool
rumbleGamepad gamepad lowFreq highFreq duration = liftIO $ rumbleGamepadFFI gamepad lowFreq highFreq duration
{-# INLINE rumbleGamepad #-}

rumbleGamepadTriggers :: MonadIO m => Gamepad -> Word16 -> Word16 -> Word32 -> m CBool
rumbleGamepadTriggers gamepad leftRumble rightRumble duration = liftIO $ rumbleGamepadTriggersFFI gamepad leftRumble rightRumble duration
{-# INLINE rumbleGamepadTriggers #-}

setGamepadLED :: MonadIO m => Gamepad -> Word8 -> Word8 -> Word8 -> m CBool
setGamepadLED gamepad red green blue = liftIO $ setGamepadLEDFFI gamepad red green blue
{-# INLINE setGamepadLED #-}

sendGamepadEffect :: MonadIO m => Gamepad -> Ptr () -> CInt -> m CBool
sendGamepadEffect gamepad dataPtr size = liftIO $ sendGamepadEffectFFI gamepad dataPtr size
{-# INLINE sendGamepadEffect #-}

getGamepadConnectionState :: MonadIO m => Gamepad -> m JoystickConnectionState
getGamepadConnectionState gamepad = liftIO $ getGamepadConnectionStateFFI gamepad
{-# INLINE getGamepadConnectionState #-}

getGamepadPowerInfo :: MonadIO m => Gamepad -> Ptr CInt -> m PowerState
getGamepadPowerInfo gamepad percent = liftIO $ getGamepadPowerInfoFFI gamepad percent
{-# INLINE getGamepadPowerInfo #-}

gamepadHasSensor :: MonadIO m => Gamepad -> SensorType -> m CBool
gamepadHasSensor gamepad sensorType = liftIO $ gamepadHasSensorFFI gamepad sensorType
{-# INLINE gamepadHasSensor #-}

setGamepadSensorEnabled :: MonadIO m => Gamepad -> SensorType -> CBool -> m CBool
setGamepadSensorEnabled gamepad sensorType enabled = liftIO $ setGamepadSensorEnabledFFI gamepad sensorType enabled
{-# INLINE setGamepadSensorEnabled #-}

gamepadSensorEnabled :: MonadIO m => Gamepad -> SensorType -> m CBool
gamepadSensorEnabled gamepad sensorType = liftIO $ gamepadSensorEnabledFFI gamepad sensorType
{-# INLINE gamepadSensorEnabled #-}

getGamepadSensorDataRate :: MonadIO m => Gamepad -> SensorType -> m Float
getGamepadSensorDataRate gamepad sensorType = liftIO $ fmap realToFrac $ getGamepadSensorDataRateFFI gamepad sensorType
{-# INLINE getGamepadSensorDataRate #-}

getGamepadSensorData :: MonadIO m => Gamepad -> SensorType -> Ptr CFloat -> CInt -> m CBool
getGamepadSensorData gamepad sensorType dataPtr numValues = liftIO $ getGamepadSensorDataFFI gamepad sensorType dataPtr numValues
{-# INLINE getGamepadSensorData #-}

addGamepadMapping :: MonadIO m => CString -> m CInt
addGamepadMapping mapping = liftIO $ addGamepadMappingFFI mapping
{-# INLINE addGamepadMapping #-}

addGamepadMappingsFromFile :: MonadIO m => CString -> m CInt
addGamepadMappingsFromFile file = liftIO $ addGamepadMappingsFromFileFFI file
{-# INLINE addGamepadMappingsFromFile #-}

reloadGamepadMappings :: MonadIO m => m CBool
reloadGamepadMappings = liftIO reloadGamepadMappingsFFI
{-# INLINE reloadGamepadMappings #-}

getGamepadMappings :: MonadIO m => Ptr CInt -> m (Ptr CString)
getGamepadMappings count = liftIO $ getGamepadMappingsFFI count
{-# INLINE getGamepadMappings #-}

getGamepadMappingForGUID :: MonadIO m => Ptr GUID -> m CString
getGamepadMappingForGUID guid = liftIO $ getGamepadMappingForGUIDFFI guid
{-# INLINE getGamepadMappingForGUID #-}

getGamepadMapping :: MonadIO m => Gamepad -> m CString
getGamepadMapping gamepad = liftIO $ getGamepadMappingFFI gamepad
{-# INLINE getGamepadMapping #-}

setGamepadMapping :: MonadIO m => JoystickID -> CString -> m CBool
setGamepadMapping instanceId mapping = liftIO $ setGamepadMappingFFI instanceId mapping
{-# INLINE setGamepadMapping #-}

getGamepadBindings :: MonadIO m => Gamepad -> Ptr CInt -> m (Ptr (Ptr SDL.Raw.Types.GamepadBinding))
getGamepadBindings gamepad count = liftIO $ getGamepadBindingsFFI gamepad count
{-# INLINE getGamepadBindings #-}

getGamepadTypeFromString :: MonadIO m => CString -> m GamepadType
getGamepadTypeFromString str = liftIO $ getGamepadTypeFromStringFFI str
{-# INLINE getGamepadTypeFromString #-}

getGamepadStringForType :: MonadIO m => GamepadType -> m CString
getGamepadStringForType gtype = liftIO $ getGamepadStringForTypeFFI gtype
{-# INLINE getGamepadStringForType #-}

getGamepadAxisFromString :: MonadIO m => CString -> m GamepadAxis
getGamepadAxisFromString str = liftIO $ getGamepadAxisFromStringFFI str
{-# INLINE getGamepadAxisFromString #-}

getGamepadStringForAxis :: MonadIO m => GamepadAxis -> m CString
getGamepadStringForAxis axis = liftIO $ getGamepadStringForAxisFFI axis
{-# INLINE getGamepadStringForAxis #-}

getGamepadButtonFromString :: MonadIO m => CString -> m GamepadButton
getGamepadButtonFromString str = liftIO $ getGamepadButtonFromStringFFI str
{-# INLINE getGamepadButtonFromString #-}

getGamepadStringForButton :: MonadIO m => GamepadButton -> m CString
getGamepadStringForButton button = liftIO $ getGamepadStringForButtonFFI button
{-# INLINE getGamepadStringForButton #-}

getGamepadAppleSFSymbolsNameForButton :: MonadIO m => Gamepad -> GamepadButton -> m CString
getGamepadAppleSFSymbolsNameForButton gamepad button = liftIO $ getGamepadAppleSFSymbolsNameForButtonFFI gamepad button
{-# INLINE getGamepadAppleSFSymbolsNameForButton #-}

getGamepadAppleSFSymbolsNameForAxis :: MonadIO m => Gamepad -> GamepadAxis -> m CString
getGamepadAppleSFSymbolsNameForAxis gamepad axis = liftIO $ getGamepadAppleSFSymbolsNameForAxisFFI gamepad axis
{-# INLINE getGamepadAppleSFSymbolsNameForAxis #-}

-- Helper function wrappers for GUID
gamepadGetGUIDForID :: MonadIO m => JoystickID -> m GUID
gamepadGetGUIDForID instanceId = liftIO $ alloca $ \ptr -> do
  gamepadGetGUIDForIDFFI instanceId ptr
  peek ptr
{-# INLINE gamepadGetGUIDForID #-}

gamepadGetGUID :: MonadIO m => Gamepad -> m GUID
gamepadGetGUID gamepad = liftIO $ alloca $ \ptr -> do
  gamepadGetGUIDFFI gamepad ptr
  peek ptr
{-# INLINE gamepadGetGUID #-}

gamepadGetGUIDFromString :: MonadIO m => CString -> m GUID
gamepadGetGUIDFromString str = liftIO $ alloca $ \ptr -> do
  gamepadGetGUIDFromStringFFI str ptr
  peek ptr
{-# INLINE gamepadGetGUIDFromString #-}

gamepadGetGUIDString :: MonadIO m => GUID -> CString -> CInt -> m ()
gamepadGetGUIDString guid str len = liftIO $ do
  with guid $ \ptr -> gamepadGetGUIDStringFFI ptr str len
{-# INLINE gamepadGetGUIDString #-}
