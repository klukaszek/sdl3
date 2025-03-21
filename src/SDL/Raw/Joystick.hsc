{-# LANGUAGE ForeignFunctionInterface #-}

module SDL.Raw.Joystick
  ( -- Basic joystick management
    lockJoysticks
  , unlockJoysticks
  , hasJoystick
  , getJoysticks
  , openJoystick
  , getJoystickFromID
  , closeJoystick

  , -- Joystick properties
    getJoystickNameForID
  , getJoystickPathForID
  , getJoystickPlayerIndexForID
  , getJoystickGUIDForID
  , getJoystickVendorForID
  , getJoystickProductForID
  , getJoystickProductVersionForID
  , getJoystickTypeForID
  , getJoystickID
  , getJoystickName
  , getJoystickPath
  , getJoystickPlayerIndex
  , setJoystickPlayerIndex
  , getJoystickGUID
  , getJoystickVendor
  , getJoystickProduct
  , getJoystickProductVersion
  , getJoystickFirmwareVersion
  , getJoystickSerial
  , getJoystickType
  , joystickConnected
  , isJoystickVirtual

  , -- Joystick state
    getNumJoystickAxes
  , getNumJoystickBalls
  , getNumJoystickHats
  , getNumJoystickButtons
  , getJoystickAxis
  , getJoystickBall
  , getJoystickHat
  , getJoystickButton

  , -- Event handling
    setJoystickEventsEnabled
  , joystickEventsEnabled
  , updateJoysticks

  , -- Rumble and LED
    rumbleJoystick
  , rumbleJoystickTriggers
  , setJoystickLED

  , -- Connection and power
    getJoystickConnectionState
  , getJoystickPowerInfo

  , -- Helper functions from sdlhelper.c
    joystickGetDeviceGUID
  , joystickGetGUID
  , joystickGetGUIDFromString
  , joystickGetGUIDString
  ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Int (Int16)
import Data.Word (Word8, Word16, Word32)
import Foreign.C.Types (CInt(..))  -- Explicitly import constructor
import Foreign.C.String (CString)
import Foreign.Ptr (Ptr, castPtr)
import Foreign.Marshal.Alloc
import Foreign.Marshal.Utils
import Foreign.Storable (peek)
import SDL.Raw.Types (Joystick, JoystickID, JoystickGUID)
import SDL.Raw.Enum (JoystickType, JoystickConnectionState, PowerState)

-- Basic joystick management
foreign import ccall "SDL3/SDL_joystick.h SDL_LockJoysticks" lockJoysticksFFI :: IO ()
foreign import ccall "SDL3/SDL_joystick.h SDL_UnlockJoysticks" unlockJoysticksFFI :: IO ()
foreign import ccall "SDL3/SDL_joystick.h SDL_HasJoystick" hasJoystickFFI :: IO Bool
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoysticks" getJoysticksFFI :: Ptr CInt -> IO (Ptr JoystickID)
foreign import ccall "SDL3/SDL_joystick.h SDL_OpenJoystick" openJoystickFFI :: JoystickID -> IO Joystick
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickFromID" getJoystickFromIDFFI :: JoystickID -> IO Joystick
foreign import ccall "SDL3/SDL_joystick.h SDL_CloseJoystick" closeJoystickFFI :: Joystick -> IO ()

-- Joystick properties
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickNameForID" getJoystickNameForIDFFI :: JoystickID -> IO CString
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickPathForID" getJoystickPathForIDFFI :: JoystickID -> IO CString
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickPlayerIndexForID" getJoystickPlayerIndexForIDFFI :: JoystickID -> IO CInt
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickGUIDForID" getJoystickGUIDForIDFFI :: JoystickID -> IO (Ptr JoystickGUID)
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickVendorForID" getJoystickVendorForIDFFI :: JoystickID -> IO Word16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickProductForID" getJoystickProductForIDFFI :: JoystickID -> IO Word16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickProductVersionForID" getJoystickProductVersionForIDFFI :: JoystickID -> IO Word16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickTypeForID" getJoystickTypeForIDFFI :: JoystickID -> IO JoystickType
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickID" getJoystickIDFFI :: Joystick -> IO JoystickID
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickName" getJoystickNameFFI :: Joystick -> IO CString
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickPath" getJoystickPathFFI :: Joystick -> IO CString
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickPlayerIndex" getJoystickPlayerIndexFFI :: Joystick -> IO CInt
foreign import ccall "SDL3/SDL_joystick.h SDL_SetJoystickPlayerIndex" setJoystickPlayerIndexFFI :: Joystick -> CInt -> IO Bool
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickGUID" getJoystickGUIDFFI :: Joystick -> IO (Ptr JoystickGUID)
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickVendor" getJoystickVendorFFI :: Joystick -> IO Word16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickProduct" getJoystickProductFFI :: Joystick -> IO Word16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickProductVersion" getJoystickProductVersionFFI :: Joystick -> IO Word16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickFirmwareVersion" getJoystickFirmwareVersionFFI :: Joystick -> IO Word16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickSerial" getJoystickSerialFFI :: Joystick -> IO CString
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickType" getJoystickTypeFFI :: Joystick -> IO JoystickType
foreign import ccall "SDL3/SDL_joystick.h SDL_JoystickConnected" joystickConnectedFFI :: Joystick -> IO Bool
foreign import ccall "SDL3/SDL_joystick.h SDL_IsJoystickVirtual" isJoystickVirtualFFI :: JoystickID -> IO Bool

-- Joystick state
foreign import ccall "SDL3/SDL_joystick.h SDL_GetNumJoystickAxes" getNumJoystickAxesFFI :: Joystick -> IO CInt
foreign import ccall "SDL3/SDL_joystick.h SDL_GetNumJoystickBalls" getNumJoystickBallsFFI :: Joystick -> IO CInt
foreign import ccall "SDL3/SDL_joystick.h SDL_GetNumJoystickHats" getNumJoystickHatsFFI :: Joystick -> IO CInt
foreign import ccall "SDL3/SDL_joystick.h SDL_GetNumJoystickButtons" getNumJoystickButtonsFFI :: Joystick -> IO CInt
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickAxis" getJoystickAxisFFI :: Joystick -> CInt -> IO Int16
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickBall" getJoystickBallFFI :: Joystick -> CInt -> Ptr CInt -> Ptr CInt -> IO Bool
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickHat" getJoystickHatFFI :: Joystick -> CInt -> IO Word8
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickButton" getJoystickButtonFFI :: Joystick -> CInt -> IO Bool

-- Event handling
foreign import ccall "SDL3/SDL_joystick.h SDL_SetJoystickEventsEnabled" setJoystickEventsEnabledFFI :: Bool -> IO ()
foreign import ccall "SDL3/SDL_joystick.h SDL_JoystickEventsEnabled" joystickEventsEnabledFFI :: IO Bool
foreign import ccall "SDL3/SDL_joystick.h SDL_UpdateJoysticks" updateJoysticksFFI :: IO ()

-- Rumble and LED
foreign import ccall "SDL3/SDL_joystick.h SDL_RumbleJoystick" rumbleJoystickFFI :: Joystick -> Word16 -> Word16 -> Word32 -> IO Bool
foreign import ccall "SDL3/SDL_joystick.h SDL_RumbleJoystickTriggers" rumbleJoystickTriggersFFI :: Joystick -> Word16 -> Word16 -> Word32 -> IO Bool
foreign import ccall "SDL3/SDL_joystick.h SDL_SetJoystickLED" setJoystickLEDFFI :: Joystick -> Word8 -> Word8 -> Word8 -> IO Bool

-- Connection and power
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickConnectionState" getJoystickConnectionStateFFI :: Joystick -> IO JoystickConnectionState
foreign import ccall "SDL3/SDL_joystick.h SDL_GetJoystickPowerInfo" getJoystickPowerInfoFFI :: Joystick -> Ptr CInt -> IO PowerState

-- Helper functions from sdlhelper.c
foreign import ccall "sdlhelper.h SDLHelper_JoystickGetDeviceGUID" joystickGetDeviceGUIDFFI :: CInt -> Ptr JoystickGUID -> IO ()
foreign import ccall "sdlhelper.h SDLHelper_JoystickGetGUID" joystickGetGUIDFFI :: Joystick -> Ptr JoystickGUID -> IO ()
foreign import ccall "sdlhelper.h SDLHelper_JoystickGetGUIDFromString" joystickGetGUIDFromStringFFI :: CString -> Ptr JoystickGUID -> IO ()
foreign import ccall "sdlhelper.h SDLHelper_JoystickGetGUIDString" joystickGetGUIDStringFFI :: Ptr JoystickGUID -> CString -> CInt -> IO ()

-- Wrapper functions
lockJoysticks :: MonadIO m => m ()
lockJoysticks = liftIO lockJoysticksFFI
{-# INLINE lockJoysticks #-}

unlockJoysticks :: MonadIO m => m ()
unlockJoysticks = liftIO unlockJoysticksFFI
{-# INLINE unlockJoysticks #-}

hasJoystick :: MonadIO m => m Bool
hasJoystick = liftIO hasJoystickFFI
{-# INLINE hasJoystick #-}

getJoysticks :: MonadIO m => Ptr CInt -> m (Ptr JoystickID)
getJoysticks count = liftIO $ getJoysticksFFI count
{-# INLINE getJoysticks #-}

openJoystick :: MonadIO m => JoystickID -> m Joystick
openJoystick instanceId = liftIO $ openJoystickFFI instanceId
{-# INLINE openJoystick #-}

getJoystickFromID :: MonadIO m => JoystickID -> m Joystick
getJoystickFromID instanceId = liftIO $ getJoystickFromIDFFI instanceId
{-# INLINE getJoystickFromID #-}

closeJoystick :: MonadIO m => Joystick -> m ()
closeJoystick joystick = liftIO $ closeJoystickFFI joystick
{-# INLINE closeJoystick #-}

getJoystickNameForID :: MonadIO m => JoystickID -> m CString
getJoystickNameForID instanceId = liftIO $ getJoystickNameForIDFFI instanceId
{-# INLINE getJoystickNameForID #-}

getJoystickPathForID :: MonadIO m => JoystickID -> m CString
getJoystickPathForID instanceId = liftIO $ getJoystickPathForIDFFI instanceId
{-# INLINE getJoystickPathForID #-}

getJoystickPlayerIndexForID :: MonadIO m => JoystickID -> m CInt
getJoystickPlayerIndexForID instanceId = liftIO $ getJoystickPlayerIndexForIDFFI instanceId
{-# INLINE getJoystickPlayerIndexForID #-}

getJoystickGUIDForID :: MonadIO m => JoystickID -> m (Ptr JoystickGUID)
getJoystickGUIDForID instanceId = liftIO $ getJoystickGUIDForIDFFI instanceId
{-# INLINE getJoystickGUIDForID #-}

getJoystickVendorForID :: MonadIO m => JoystickID -> m Word16
getJoystickVendorForID instanceId = liftIO $ getJoystickVendorForIDFFI instanceId
{-# INLINE getJoystickVendorForID #-}

getJoystickProductForID :: MonadIO m => JoystickID -> m Word16
getJoystickProductForID instanceId = liftIO $ getJoystickProductForIDFFI instanceId
{-# INLINE getJoystickProductForID #-}

getJoystickProductVersionForID :: MonadIO m => JoystickID -> m Word16
getJoystickProductVersionForID instanceId = liftIO $ getJoystickProductVersionForIDFFI instanceId
{-# INLINE getJoystickProductVersionForID #-}

getJoystickTypeForID :: MonadIO m => JoystickID -> m JoystickType
getJoystickTypeForID instanceId = liftIO $ getJoystickTypeForIDFFI instanceId
{-# INLINE getJoystickTypeForID #-}

getJoystickID :: MonadIO m => Joystick -> m JoystickID
getJoystickID joystick = liftIO $ getJoystickIDFFI joystick
{-# INLINE getJoystickID #-}

getJoystickName :: MonadIO m => Joystick -> m CString
getJoystickName joystick = liftIO $ getJoystickNameFFI joystick
{-# INLINE getJoystickName #-}

getJoystickPath :: MonadIO m => Joystick -> m CString
getJoystickPath joystick = liftIO $ getJoystickPathFFI joystick
{-# INLINE getJoystickPath #-}

getJoystickPlayerIndex :: MonadIO m => Joystick -> m CInt
getJoystickPlayerIndex joystick = liftIO $ getJoystickPlayerIndexFFI joystick
{-# INLINE getJoystickPlayerIndex #-}

setJoystickPlayerIndex :: MonadIO m => Joystick -> CInt -> m Bool
setJoystickPlayerIndex joystick playerIndex = liftIO $ setJoystickPlayerIndexFFI joystick playerIndex
{-# INLINE setJoystickPlayerIndex #-}

getJoystickGUID :: MonadIO m => Joystick -> m (Ptr JoystickGUID)
getJoystickGUID joystick = liftIO $ getJoystickGUIDFFI joystick
{-# INLINE getJoystickGUID #-}

getJoystickVendor :: MonadIO m => Joystick -> m Word16
getJoystickVendor joystick = liftIO $ getJoystickVendorFFI joystick
{-# INLINE getJoystickVendor #-}

getJoystickProduct :: MonadIO m => Joystick -> m Word16
getJoystickProduct joystick = liftIO $ getJoystickProductFFI joystick
{-# INLINE getJoystickProduct #-}

getJoystickProductVersion :: MonadIO m => Joystick -> m Word16
getJoystickProductVersion joystick = liftIO $ getJoystickProductVersionFFI joystick
{-# INLINE getJoystickProductVersion #-}

getJoystickFirmwareVersion :: MonadIO m => Joystick -> m Word16
getJoystickFirmwareVersion joystick = liftIO $ getJoystickFirmwareVersionFFI joystick
{-# INLINE getJoystickFirmwareVersion #-}

getJoystickSerial :: MonadIO m => Joystick -> m CString
getJoystickSerial joystick = liftIO $ getJoystickSerialFFI joystick
{-# INLINE getJoystickSerial #-}

getJoystickType :: MonadIO m => Joystick -> m JoystickType
getJoystickType joystick = liftIO $ getJoystickTypeFFI joystick
{-# INLINE getJoystickType #-}

joystickConnected :: MonadIO m => Joystick -> m Bool
joystickConnected joystick = liftIO $ joystickConnectedFFI joystick
{-# INLINE joystickConnected #-}

isJoystickVirtual :: MonadIO m => JoystickID -> m Bool
isJoystickVirtual instanceId = liftIO $ isJoystickVirtualFFI instanceId
{-# INLINE isJoystickVirtual #-}

getNumJoystickAxes :: MonadIO m => Joystick -> m CInt
getNumJoystickAxes joystick = liftIO $ getNumJoystickAxesFFI joystick
{-# INLINE getNumJoystickAxes #-}

getNumJoystickBalls :: MonadIO m => Joystick -> m CInt
getNumJoystickBalls joystick = liftIO $ getNumJoystickBallsFFI joystick
{-# INLINE getNumJoystickBalls #-}

getNumJoystickHats :: MonadIO m => Joystick -> m CInt
getNumJoystickHats joystick = liftIO $ getNumJoystickHatsFFI joystick
{-# INLINE getNumJoystickHats #-}

getNumJoystickButtons :: MonadIO m => Joystick -> m CInt
getNumJoystickButtons joystick = liftIO $ getNumJoystickButtonsFFI joystick
{-# INLINE getNumJoystickButtons #-}

getJoystickAxis :: MonadIO m => Joystick -> CInt -> m Int16
getJoystickAxis joystick axis = liftIO $ getJoystickAxisFFI joystick axis
{-# INLINE getJoystickAxis #-}

getJoystickBall :: MonadIO m => Joystick -> CInt -> Ptr CInt -> Ptr CInt -> m Bool
getJoystickBall joystick ball dx dy = liftIO $ getJoystickBallFFI joystick ball dx dy
{-# INLINE getJoystickBall #-}

getJoystickHat :: MonadIO m => Joystick -> CInt -> m Word8
getJoystickHat joystick hat = liftIO $ getJoystickHatFFI joystick hat
{-# INLINE getJoystickHat #-}

getJoystickButton :: MonadIO m => Joystick -> CInt -> m Bool
getJoystickButton joystick button = liftIO $ getJoystickButtonFFI joystick button
{-# INLINE getJoystickButton #-}

setJoystickEventsEnabled :: MonadIO m => Bool -> m ()
setJoystickEventsEnabled enabled = liftIO $ setJoystickEventsEnabledFFI enabled
{-# INLINE setJoystickEventsEnabled #-}

joystickEventsEnabled :: MonadIO m => m Bool
joystickEventsEnabled = liftIO joystickEventsEnabledFFI
{-# INLINE joystickEventsEnabled #-}

updateJoysticks :: MonadIO m => m ()
updateJoysticks = liftIO updateJoysticksFFI
{-# INLINE updateJoysticks #-}

rumbleJoystick :: MonadIO m => Joystick -> Word16 -> Word16 -> Word32 -> m Bool
rumbleJoystick joystick lowFreq highFreq duration = liftIO $ rumbleJoystickFFI joystick lowFreq highFreq duration
{-# INLINE rumbleJoystick #-}

rumbleJoystickTriggers :: MonadIO m => Joystick -> Word16 -> Word16 -> Word32 -> m Bool
rumbleJoystickTriggers joystick leftRumble rightRumble duration = liftIO $ rumbleJoystickTriggersFFI joystick leftRumble rightRumble duration
{-# INLINE rumbleJoystickTriggers #-}

setJoystickLED :: MonadIO m => Joystick -> Word8 -> Word8 -> Word8 -> m Bool
setJoystickLED joystick red green blue = liftIO $ setJoystickLEDFFI joystick red green blue
{-# INLINE setJoystickLED #-}

getJoystickConnectionState :: MonadIO m => Joystick -> m JoystickConnectionState
getJoystickConnectionState joystick = liftIO $ getJoystickConnectionStateFFI joystick
{-# INLINE getJoystickConnectionState #-}

getJoystickPowerInfo :: MonadIO m => Joystick -> Ptr CInt -> m PowerState
getJoystickPowerInfo joystick percent = liftIO $ getJoystickPowerInfoFFI joystick percent
{-# INLINE getJoystickPowerInfo #-}

-- Helper function wrappers
joystickGetDeviceGUID :: MonadIO m => CInt -> m JoystickGUID
joystickGetDeviceGUID deviceIndex = liftIO $ alloca $ \ptr -> do
  joystickGetDeviceGUIDFFI deviceIndex ptr
  peek ptr
{-# INLINE joystickGetDeviceGUID #-}

joystickGetGUID :: MonadIO m => Joystick -> m JoystickGUID
joystickGetGUID joystick = liftIO $ alloca $ \ptr -> do
  joystickGetGUIDFFI joystick ptr
  peek ptr
{-# INLINE joystickGetGUID #-}

joystickGetGUIDFromString :: MonadIO m => CString -> m JoystickGUID
joystickGetGUIDFromString str = liftIO $ alloca $ \ptr -> do
  joystickGetGUIDFromStringFFI str ptr
  peek ptr
{-# INLINE joystickGetGUIDFromString #-}

joystickGetGUIDString :: MonadIO m => JoystickGUID -> CString -> CInt -> m ()
joystickGetGUIDString guid str len = liftIO $ do
  with guid $ \ptr -> joystickGetGUIDStringFFI ptr str len
{-# INLINE joystickGetGUIDString #-}
