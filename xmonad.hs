import XMonad

-- xmonad
import XMonad.Util.Run
import XMonad.Hooks.DynamicLog

-- internal imports
import Settings.GlobalVariables
import Settings.Keys
import Settings.Layout
import Settings.Colors
import Settings.StatusBar
import Settings.Startup

-- xmonad-contrib
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.Loggers.NamedScratchpad
import XMonad.Util.NamedScratchpad

-- system
import Data.Maybe
import System.Environment

getEnvVar :: String -> String -> IO String
getEnvVar env defaultVar = do
  var <- lookupEnv env
  return $ fromMaybe defaultVar var

main = do
  -- setup wallpaper
  spawn "feh --bg-scale --randomize ~/.cache/wallpaper/*"
  -- terminal daemon
  spawn "urxvtd"
  -- set status bar
  barProcess <- myStatusBarSetup
  -- setup colors
  foreground <- getEnvVar "foreground" "#ffffff"
  background <- getEnvVar "background" "#000000"
  -- starting some prgrams...
  xmonad
    $ docks
    $ ewmh
    $ def { terminal    = myTerminal
          , borderWidth = myBorderWidth
          , keys        = myKeys
          , focusedBorderColor = foreground
          , normalBorderColor  = background
          , logHook = myEventLogHook barProcess
          , startupHook = nspTrackStartup scratchpads
          , layoutHook = avoidStruts myDefaultLayout
          , manageHook = manageHook def <+>
                         manageSpawn <+>
                         namedScratchpadManageHook scratchpads
          , handleEventHook = handleEventHook def <+>
                              nspTrackHook scratchpads
          }
