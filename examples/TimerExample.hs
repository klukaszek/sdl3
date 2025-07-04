import Control.Monad (when)
import Foreign.Ptr (nullPtr)
import SDL

main :: IO ()
main = do
  -- Measure elapsed time
  start <- sdlGetTicks
  sdlDelay 1000 -- Wait 1 second
  end <- sdlGetTicks
  sdlLog $ "Elapsed time: " ++ show (end - start) ++ " ms"

  -- Add a timer callback
  let callback :: SDLTimerCallback
      callback _ timerID interval = do
        sdlLog $ "Timer " ++ show timerID ++ " fired after " ++ show interval ++ " ms"
        return 0 -- Stop the timer after one run
  timerID <- sdlAddTimer 500 callback nullPtr
  when (timerID /= 0) $ do
    sdlLog $ "Timer added with ID: " ++ show timerID
    sdlDelay 1000 -- Wait to see the timer fire
    sdlRemoveTimer timerID >>= print
