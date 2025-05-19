{-# LANGUAGE CPP #-}
{-# LANGUAGE ForeignFunctionInterface #-}

#include <SDL3/SDL_platform.h>

{-|
Module      : SDL.Platform
Description : SDL platform identification
Copyright   : (c) Kyle Lukaszek, 2025
License     : BSD3

This module provides functionality to identify the application's platform,
both at compile time and runtime.
-}

module SDL.Platform
  ( -- * Platform Information
    sdlGetPlatform

    -- * Platform Constants
  , sdlPlatformWindows
  , sdlPlatformMacOS
  , sdlPlatformLinux
  , sdlPlatformIOS
  , sdlPlatformAndroid
  , sdlPlatformTVOS
  , sdlPlatformVisionOS
  , sdlPlatformEmscripten
  , sdlPlatformHaiku
  , sdlPlatformUnix
  , sdlPlatformApple
  , sdlPlatformNetBSD
  , sdlPlatformOpenBSD
  , sdlPlatformFreeBSD
  , sdlPlatformBSDI
  , sdlPlatformOS2
  , sdlPlatformSolaris
  , sdlPlatformCygwin
  , sdlPlatformWin32
  , sdlPlatformXboxOne
  , sdlPlatformXboxSeries
  , sdlPlatformWinGDK
  , sdlPlatformGDK
  , sdlPlatformPSP
  , sdlPlatformPS2
  , sdlPlatformVita
  , sdlPlatform3DS
  ) where

import Foreign.C.String (CString, peekCString)

-- | Get the name of the platform.
--
-- Common platform names include:
-- * "Windows"
-- * "macOS"
-- * "Linux"
-- * "iOS"
-- * "Android"
--
-- If the correct platform name is not available, returns a string
-- beginning with "Unknown".
foreign import ccall "SDL_GetPlatform"
  sdlGetPlatform_c :: IO CString

sdlGetPlatform :: IO String
sdlGetPlatform = sdlGetPlatform_c >>= peekCString

-- Platform compile-time constants
#ifdef SDL_PLATFORM_WINDOWS
sdlPlatformWindows :: Bool
sdlPlatformWindows = True
#else
sdlPlatformWindows :: Bool
sdlPlatformWindows = False
#endif

#ifdef SDL_PLATFORM_MACOS
sdlPlatformMacOS :: Bool
sdlPlatformMacOS = True
#else
sdlPlatformMacOS :: Bool
sdlPlatformMacOS = False
#endif

#ifdef SDL_PLATFORM_LINUX
sdlPlatformLinux :: Bool
sdlPlatformLinux = True
#else
sdlPlatformLinux :: Bool
sdlPlatformLinux = False
#endif

#ifdef SDL_PLATFORM_IOS
sdlPlatformIOS :: Bool
sdlPlatformIOS = True
#else
sdlPlatformIOS :: Bool
sdlPlatformIOS = False
#endif

#ifdef SDL_PLATFORM_ANDROID
sdlPlatformAndroid :: Bool
sdlPlatformAndroid = True
#else
sdlPlatformAndroid :: Bool
sdlPlatformAndroid = False
#endif

#ifdef SDL_PLATFORM_TVOS
sdlPlatformTVOS :: Bool
sdlPlatformTVOS = True
#else
sdlPlatformTVOS :: Bool
sdlPlatformTVOS = False
#endif

#ifdef SDL_PLATFORM_VISIONOS
sdlPlatformVisionOS :: Bool
sdlPlatformVisionOS = True
#else
sdlPlatformVisionOS :: Bool
sdlPlatformVisionOS = False
#endif

#ifdef SDL_PLATFORM_EMSCRIPTEN
sdlPlatformEmscripten :: Bool
sdlPlatformEmscripten = True
#else
sdlPlatformEmscripten :: Bool
sdlPlatformEmscripten = False
#endif

#ifdef SDL_PLATFORM_HAIKU
sdlPlatformHaiku :: Bool
sdlPlatformHaiku = True
#else
sdlPlatformHaiku :: Bool
sdlPlatformHaiku = False
#endif

#ifdef SDL_PLATFORM_UNIX
sdlPlatformUnix :: Bool
sdlPlatformUnix = True
#else
sdlPlatformUnix :: Bool
sdlPlatformUnix = False
#endif

#ifdef SDL_PLATFORM_APPLE
sdlPlatformApple :: Bool
sdlPlatformApple = True
#else
sdlPlatformApple :: Bool
sdlPlatformApple = False
#endif

#ifdef SDL_PLATFORM_NETBSD
sdlPlatformNetBSD :: Bool
sdlPlatformNetBSD = True
#else
sdlPlatformNetBSD :: Bool
sdlPlatformNetBSD = False
#endif

#ifdef SDL_PLATFORM_OPENBSD
sdlPlatformOpenBSD :: Bool
sdlPlatformOpenBSD = True
#else
sdlPlatformOpenBSD :: Bool
sdlPlatformOpenBSD = False
#endif

#ifdef SDL_PLATFORM_FREEBSD
sdlPlatformFreeBSD :: Bool
sdlPlatformFreeBSD = True
#else
sdlPlatformFreeBSD :: Bool
sdlPlatformFreeBSD = False
#endif

#ifdef SDL_PLATFORM_BSDI
sdlPlatformBSDI :: Bool
sdlPlatformBSDI = True
#else
sdlPlatformBSDI :: Bool
sdlPlatformBSDI = False
#endif

#ifdef SDL_PLATFORM_OS2
sdlPlatformOS2 :: Bool
sdlPlatformOS2 = True
#else
sdlPlatformOS2 :: Bool
sdlPlatformOS2 = False
#endif

#ifdef SDL_PLATFORM_SOLARIS
sdlPlatformSolaris :: Bool
sdlPlatformSolaris = True
#else
sdlPlatformSolaris :: Bool
sdlPlatformSolaris = False
#endif

#ifdef SDL_PLATFORM_CYGWIN
sdlPlatformCygwin :: Bool
sdlPlatformCygwin = True
#else
sdlPlatformCygwin :: Bool
sdlPlatformCygwin = False
#endif

#ifdef SDL_PLATFORM_WIN32
sdlPlatformWin32 :: Bool
sdlPlatformWin32 = True
#else
sdlPlatformWin32 :: Bool
sdlPlatformWin32 = False
#endif

#ifdef SDL_PLATFORM_XBOXONE
sdlPlatformXboxOne :: Bool
sdlPlatformXboxOne = True
#else
sdlPlatformXboxOne :: Bool
sdlPlatformXboxOne = False
#endif

#ifdef SDL_PLATFORM_XBOXSERIES
sdlPlatformXboxSeries :: Bool
sdlPlatformXboxSeries = True
#else
sdlPlatformXboxSeries :: Bool
sdlPlatformXboxSeries = False
#endif

#ifdef SDL_PLATFORM_WINGDK
sdlPlatformWinGDK :: Bool
sdlPlatformWinGDK = True
#else
sdlPlatformWinGDK :: Bool
sdlPlatformWinGDK = False
#endif

#ifdef SDL_PLATFORM_GDK
sdlPlatformGDK :: Bool
sdlPlatformGDK = True
#else
sdlPlatformGDK :: Bool
sdlPlatformGDK = False
#endif

#ifdef SDL_PLATFORM_PSP
sdlPlatformPSP :: Bool
sdlPlatformPSP = True
#else
sdlPlatformPSP :: Bool
sdlPlatformPSP = False
#endif

#ifdef SDL_PLATFORM_PS2
sdlPlatformPS2 :: Bool
sdlPlatformPS2 = True
#else
sdlPlatformPS2 :: Bool
sdlPlatformPS2 = False
#endif

#ifdef SDL_PLATFORM_VITA
sdlPlatformVita :: Bool
sdlPlatformVita = True
#else
sdlPlatformVita :: Bool
sdlPlatformVita = False
#endif

#ifdef SDL_PLATFORM_3DS
sdlPlatform3DS :: Bool
sdlPlatform3DS = True
#else
sdlPlatform3DS :: Bool
sdlPlatform3DS = False
#endif
