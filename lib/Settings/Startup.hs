module Settings.Startup where

import           XMonad

import           Settings.GlobalVariables

--spawn once
import           XMonad.Actions.SpawnOn

myStartupHook :: X ()
myStartupHook = composeAll
  [ spawnOn "8" $ myTerminal <> " -e spt"
  , spawnOn "8" $ myTerminal <> " -e cava"
  , spawnOn "8" $ myTerminal <> " -e pulsemixer"
  , spawnOn "9" $ myTerminal <> " -e emacs -e (mu4e)"
  , spawnOn "9" "telegram-desktop"
  ]
