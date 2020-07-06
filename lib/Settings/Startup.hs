module Settings.Startup where

import XMonad

import Settings.GlobalVariables

--spawn once
import XMonad.Actions.SpawnOn

myStartupHook :: X ()
myStartupHook = composeAll
  [ spawnOn "7" $ myTerminal <> " -e bashtop"
  , spawnOn "8" $ myTerminal <> " -e ncmpcpp"
  , spawnOn "8" $ myTerminal <> " -e castero"
  , spawnOn "8" $ myTerminal <> " -e cava"
  -- , spawnOn "9" "emacsclient -server-file=telega -cne '(lambda () (interactive-previous-buffer)'"
  -- , spawnOn "9" "emacsclient -server-file=mail -cne '(lambda () (interactive-previous-buffer)'"
  ]
