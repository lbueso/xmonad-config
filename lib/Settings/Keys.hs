module Settings.Keys where

import Settings.GlobalVariables
import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Util.EZConfig
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W

-- scratchpad
import XMonad.Util.NamedScratchpad

myKeys = \conf -> mkKeymap conf $
  -- launch programs
  [ ("M4-<Return>", spawn myTerminal)
  , ("M4-S-g",      spawn myBrowser)
  , ("M4-d",        spawn myMenu)
  , ("M4-p",        spawn "rofi-pass")
  , ("M4-S-e",      spawn myEditor)
  , ("M4-S-t",      spawn "emacsclient -server-file=telega -cne '(telega t)'")
  , ("M4-S-m",      spawn "emacsclient -server-file=mail -cne '(mu4e)'")
  , ("M4-S-w",      spawn "emacsclient -server-file=feed -cne '(elfeed)'")
  , ("M4-S-c",      kill)
  -- launch file manager in a scratchpad
  , ("M4-S-r",      namedScratchpadAction scratchpads "ranger")
  -- change layout
  , ("M4-<Space>",   sendMessage NextLayout)
  , ("M4-S-<Space>", setLayout $ XMonad.layoutHook conf)
  -- move focus
  , ("M4-<Tab>",   windows W.focusDown)
  , ("M4-o",       windows W.focusDown)
  , ("M4-S-<Tab>", windows W.focusUp)
  -- , ("M4-n",       windows W.focusDown)
  -- , ("M4-p",       windows W.focusUp)
  -- modify the window order
  , ("M4-m",   windows W.swapMaster)
  , ("M4-S-n", windows W.swapDown)
  , ("M4-S-p", windows W.swapUp)
  -- resize the master/slave ratio
  , ("M4-h", sendMessage Shrink)
  , ("M4-l", sendMessage Expand)
  -- TODO floating layer support
  , ("M4-t", withFocused $ windows. W.sink)
  -- hide/show dock
  , ("M4-C-<Space>", sendMessage ToggleStruts)
  -- change screen
  , ("M4-f", nextScreen)
  , ("M4-b", prevScreen)
  -- swap screen
  , ("M4-S-f", swapNextScreen)
  , ("M4-S-b", swapPrevScreen)
  -- monitor brightness
  , ("<XF86MonBrightnessUp>",   spawn "light -A 2")
  , ("<XF86MonBrightnessDown>", spawn "light -U 2")
  -- , ("M4-S-=", spawn "light -A 10") -- S-= equals + in Dvorak layout
  -- , ("M4--",   spawn "light -U 10")
  -- volume keys
  , ("<XF86AudioRaiseVolume>", spawn "pulsemixer --change-volume +2")
  , ("<XF86AudioLowerVolume>", spawn "pulsemixer --change-volume -2")
  -- TODO screenshots
  -- lampe hue lights
  , ("M4-<F11>", spawn "lampe -s Y") -- switch on lights
  , ("M4-<F12>", spawn "lampe -s N") -- switch on lights
  -- quit or restart
  , ("M4-S-q", io (exitWith ExitSuccess))
  , ("M4-S-l", spawn "systemctl hibernate")
  -- restart xmonad
  -- , ("M4-S-r", spawn "xmonad --recompile")      -- Recompiles xmonad
  -- , ("M4-S-s", spawn "xmonad --restart")        -- Restarts xmonad
  ]
  ++
  [ (m ++ i, windows $ f j)
      | (i, j) <- zip (map show [1..9]) (XMonad.workspaces conf)
      , (m, f) <- [("M4-", W.view), ("M4-S-", W.shift)]
  ]
