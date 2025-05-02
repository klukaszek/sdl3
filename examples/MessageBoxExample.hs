module Main where

import SDL
import Foreign.C.Types (CInt)
import Control.Monad (unless)
import System.Exit (exitFailure, exitSuccess)

main :: IO ()
main = do
  -- Initialize SDL
  initSuccess <- sdlInit [InitVideo]
  unless initSuccess $ do
    sdlLog "Failed to initialize SDL!"
    exitFailure

  -- Create a window for our dialog
  maybeWindow <- sdlCreateWindow      
    "SDL Dialog Example"
    800 
    600 
    [SDL_WINDOW_RESIZABLE]

  sdlLog "SDL Initialized. Testing message boxes..."

  -- Simple information message box
  res1 <- showMessageBox "Info" "This is an information message box." maybeWindow [SDLMessageBoxInformation]
  sdlLog $ "User clicked: " ++ show res1

  -- Warning message box
  res2 <- showMessageBox "Warning" "This is a warning message box." maybeWindow [SDLMessageBoxWarning]
  sdlLog $ "User clicked: " ++ show res2

  -- Error message box
  res3 <- showMessageBox "Error" "This is an error message box." maybeWindow [SDLMessageBoxError]
  sdlLog $ "User clicked: " ++ show res3

  -- Message box with custom buttons
  res4 <- showCustomMessageBox "Custom" "Choose an option:" maybeWindow [("OK", 1), ("Cancel", 2)]
  sdlLog $ "User clicked: " ++ show res4

  -- Shutdown SDL
  sdlLog "Shutting down SDL..."
  sdlQuit
  sdlLog "Test completed."
  exitSuccess

-- Function to show a standard message box
showMessageBox :: String -> String -> Maybe SDLWindow -> [SDLMessageBoxFlags] -> IO (Maybe Int)
showMessageBox title msg window msgType = do
  let msgBoxData = SDLMessageBoxData
        { messageBoxFlags = msgType
        , messageBoxWindow = window
        , messageBoxTitle = title
        , messageBoxMessage = msg
        , messageBoxButtons = []
        , messageBoxColorScheme = Nothing
        }
  sdlShowMessageBox msgBoxData

-- Function to show a custom message box with buttons
showCustomMessageBox :: String -> String -> Maybe SDLWindow -> [(String, CInt)] -> IO (Maybe Int)
showCustomMessageBox title msg window buttons = do
  let buttonData = [ SDLMessageBoxButtonData [] bid txt | (txt, bid) <- buttons ]
      msgBoxData = SDLMessageBoxData
        { messageBoxFlags = [SDLMessageBoxInformation]
        , messageBoxWindow = window
        , messageBoxTitle = title
        , messageBoxMessage = msg
        , messageBoxButtons = buttonData
        , messageBoxColorScheme = Nothing
        }
  sdlShowMessageBox msgBoxData
