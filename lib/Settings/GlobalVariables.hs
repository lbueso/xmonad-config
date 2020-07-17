module Settings.GlobalVariables where

import XMonad

import Settings.StatusBar
import XMonad.Util.NamedScratchpad
import qualified XMonad.StackSet as W

-- General config
myTerminal    = "urxvt"
myBrowser     = "qutebrowser"
myEditor      = "emacsclient -c"
myMenu        = "rofi -modi drun -show drun"
myModMask     = mod4Mask
myBorderWidth = 2 :: Dimension
-- status bar
myStatusBar   = xmobar
myStatusBarSetup = xmobarSetup
myEventLogHook = xmobarLogHook
-- scratchpads
scratchpads = [ NS "ranger" (myTerminal <>  " -name ranger -e ranger") (title =? "ranger")
                (customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3))
              ]
