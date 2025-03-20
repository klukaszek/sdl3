module SDL.Raw.Filesystem (
  -- * Filesystem Paths
  getBasePath,
  getPrefPath,

  -- * File I/O Abstraction
  ioFromConstMem,
  ioFromFile,
  ioFromMem,
  ioClose,
  ioRead,
  ioSeek,
  ioTell,
  ioWrite,
  ioFlush,
  readBE16,
  readBE32,
  readBE64,
  readLE16,
  readLE32,
  readLE64,
  writeBE16,
  writeBE32,
  writeBE64,
  writeLE16,
  writeLE32,
  writeLE64
) where

import Control.Monad.IO.Class
import Data.Word
import Data.Int (Int64)
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import SDL.Raw.Types

foreign import ccall "SDL3/SDL.h SDL_GetBasePath" getBasePathFFI :: IO CString
foreign import ccall "SDL3/SDL.h SDL_GetPrefPath" getPrefPathFFI :: CString -> CString -> IO CString

foreign import ccall "SDL3/SDL.h SDL_OpenIO" openIOFFI :: Ptr IOStreamInterface -> Ptr () -> IO (Ptr IOStream)
foreign import ccall "SDL3/SDL.h SDL_CloseIO" closeIOFFI :: Ptr IOStream -> IO CBool
foreign import ccall "SDL3/SDL.h SDL_IOFromConstMem" ioFromConstMemFFI :: Ptr () -> CInt -> IO (Ptr IOStream)
foreign import ccall "SDL3/SDL.h SDL_IOFromFile" ioFromFileFFI :: CString -> CString -> IO (Ptr IOStream)
foreign import ccall "SDL3/SDL.h SDL_IOFromMem" ioFromMemFFI :: Ptr () -> CInt -> IO (Ptr IOStream)
foreign import ccall "SDL3/SDL.h SDL_ReadIO" ioReadFFI :: Ptr IOStream -> Ptr () -> CSize -> Ptr IOStatus -> IO CSize
foreign import ccall "SDL3/SDL.h SDL_SeekIO" ioSeekFFI :: Ptr IOStream -> Int64 -> IOWhence -> IO Int64
foreign import ccall "SDL3/SDL.h SDL_TellIO" ioTellFFI :: Ptr IOStream -> IO Int64
foreign import ccall "SDL3/SDL.h SDL_WriteIO" ioWriteFFI :: Ptr IOStream -> Ptr () -> CSize -> Ptr IOStatus -> IO CSize
foreign import ccall "SDL3/SDL.h SDL_FlushIO" ioFlushFFI :: Ptr IOStream -> IO CBool
foreign import ccall "SDL3/SDL.h SDL_ReadU16BE" readBE16FFI :: Ptr IOStream -> IO Word16
foreign import ccall "SDL3/SDL.h SDL_ReadU32BE" readBE32FFI :: Ptr IOStream -> IO Word32
foreign import ccall "SDL3/SDL.h SDL_ReadU64BE" readBE64FFI :: Ptr IOStream -> IO Word64
foreign import ccall "SDL3/SDL.h SDL_ReadU16LE" readLE16FFI :: Ptr IOStream -> IO Word16
foreign import ccall "SDL3/SDL.h SDL_ReadU32LE" readLE32FFI :: Ptr IOStream -> IO Word32
foreign import ccall "SDL3/SDL.h SDL_ReadU64LE" readLE64FFI :: Ptr IOStream -> IO Word64
foreign import ccall "SDL3/SDL.h SDL_WriteU16BE" writeBE16FFI :: Ptr IOStream -> Word16 -> IO CSize
foreign import ccall "SDL3/SDL.h SDL_WriteU32BE" writeBE32FFI :: Ptr IOStream -> Word32 -> IO CSize
foreign import ccall "SDL3/SDL.h SDL_WriteU64BE" writeBE64FFI :: Ptr IOStream -> Word64 -> IO CSize
foreign import ccall "SDL3/SDL.h SDL_WriteU16LE" writeLE16FFI :: Ptr IOStream -> Word16 -> IO CSize
foreign import ccall "SDL3/SDL.h SDL_WriteU32LE" writeLE32FFI :: Ptr IOStream -> Word32 -> IO CSize
foreign import ccall "SDL3/SDL.h SDL_WriteU64LE" writeLE64FFI :: Ptr IOStream -> Word64 -> IO CSize

getBasePath :: MonadIO m => m CString
getBasePath = liftIO getBasePathFFI
{-# INLINE getBasePath #-}

getPrefPath :: MonadIO m => CString -> CString -> m CString
getPrefPath v1 v2 = liftIO $ getPrefPathFFI v1 v2
{-# INLINE getPrefPath #-}

ioOpen :: MonadIO m => Ptr IOStreamInterface -> Ptr () -> m (Ptr IOStream)
ioOpen v1 v2 = liftIO $ openIOFFI v1 v2
{-# INLINE ioOpen #-}

ioFromConstMem :: MonadIO m => Ptr () -> CInt -> m (Ptr IOStream)
ioFromConstMem v1 v2 = liftIO $ ioFromConstMemFFI v1 v2
{-# INLINE ioFromConstMem #-}

ioFromFile :: MonadIO m => CString -> CString -> m (Ptr IOStream)
ioFromFile v1 v2 = liftIO $ ioFromFileFFI v1 v2
{-# INLINE ioFromFile #-}

ioFromMem :: MonadIO m => Ptr () -> CInt -> m (Ptr IOStream)
ioFromMem v1 v2 = liftIO $ ioFromMemFFI v1 v2
{-# INLINE ioFromMem #-}

ioClose :: MonadIO m => Ptr IOStream -> m CBool
ioClose v1 = liftIO $ closeIOFFI v1
{-# INLINE ioClose #-}

ioRead :: MonadIO m => Ptr IOStream -> Ptr () -> CSize -> Ptr IOStatus -> m CSize
ioRead v1 v2 v3 v4 = liftIO $ ioReadFFI v1 v2 v3 v4
{-# INLINE ioRead #-}

ioSeek :: MonadIO m => Ptr IOStream -> Int64 -> IOWhence -> m Int64
ioSeek v1 v2 v3 = liftIO $ ioSeekFFI v1 v2 v3
{-# INLINE ioSeek #-}

ioTell :: MonadIO m => Ptr IOStream -> m Int64
ioTell v1 = liftIO $ ioTellFFI v1
{-# INLINE ioTell #-}

ioWrite :: MonadIO m => Ptr IOStream -> Ptr () -> CSize -> Ptr IOStatus -> m CSize
ioWrite v1 v2 v3 v4 = liftIO $ ioWriteFFI v1 v2 v3 v4
{-# INLINE ioWrite #-}

ioFlush :: MonadIO m => Ptr IOStream -> m CBool
ioFlush v1 = liftIO $ ioFlushFFI v1
{-# INLINE ioFlush #-}

readBE16 :: MonadIO m => Ptr IOStream -> m Word16
readBE16 v1 = liftIO $ readBE16FFI v1
{-# INLINE readBE16 #-}

readBE32 :: MonadIO m => Ptr IOStream -> m Word32
readBE32 v1 = liftIO $ readBE32FFI v1
{-# INLINE readBE32 #-}

readBE64 :: MonadIO m => Ptr IOStream -> m Word64
readBE64 v1 = liftIO $ readBE64FFI v1
{-# INLINE readBE64 #-}

readLE16 :: MonadIO m => Ptr IOStream -> m Word16
readLE16 v1 = liftIO $ readLE16FFI v1
{-# INLINE readLE16 #-}

readLE32 :: MonadIO m => Ptr IOStream -> m Word32
readLE32 v1 = liftIO $ readLE32FFI v1
{-# INLINE readLE32 #-}

readLE64 :: MonadIO m => Ptr IOStream -> m Word64
readLE64 v1 = liftIO $ readLE64FFI v1
{-# INLINE readLE64 #-}

writeBE16 :: MonadIO m => Ptr IOStream -> Word16 -> m CSize
writeBE16 v1 v2 = liftIO $ writeBE16FFI v1 v2
{-# INLINE writeBE16 #-}

writeBE32 :: MonadIO m => Ptr IOStream -> Word32 -> m CSize
writeBE32 v1 v2 = liftIO $ writeBE32FFI v1 v2
{-# INLINE writeBE32 #-}

writeBE64 :: MonadIO m => Ptr IOStream -> Word64 -> m CSize
writeBE64 v1 v2 = liftIO $ writeBE64FFI v1 v2
{-# INLINE writeBE64 #-}

writeLE16 :: MonadIO m => Ptr IOStream -> Word16 -> m CSize
writeLE16 v1 v2 = liftIO $ writeLE16FFI v1 v2
{-# INLINE writeLE16 #-}

writeLE32 :: MonadIO m => Ptr IOStream -> Word32 -> m CSize
writeLE32 v1 v2 = liftIO $ writeLE32FFI v1 v2
{-# INLINE writeLE32 #-}

writeLE64 :: MonadIO m => Ptr IOStream -> Word64 -> m CSize
writeLE64 v1 v2 = liftIO $ writeLE64FFI v1 v2
{-# INLINE writeLE64 #-}
