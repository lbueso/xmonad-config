module Settings.Layout where

import XMonad
import XMonad.Actions.MouseResize

-- Hooks
import XMonad.Hooks.ManageDocks

-- Layouts
import XMonad.Layout
import XMonad.Layout.Grid
import XMonad.Layout.SimplestFloat
import XMonad.Layout.OneBig
import XMonad.Layout.ThreeColumns
import XMonad.Layout.ResizableTile
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleFloat

-- TODO real full screen
myDefaultLayout =     (Tall nmaster delta ratio)
                  -- ||| (ThreeCol nmaster delta ratio)
                  ||| (Mirror $ Tall nmaster delta ratio)
                  ||| Grid
                  ||| (noBorders Full)
                  -- ||| simpleFloat
  where
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100
