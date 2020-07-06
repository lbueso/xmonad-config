module Settings.StatusBar where

import XMonad

import Data.List (sortBy)
import Data.Function (on)
import Control.Monad (forM_, join)
import System.IO (hPutStrLn)

import XMonad.Hooks.DynamicLog (dynamicLogWithPP, defaultPP, wrap, pad, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Util.Run (safeSpawn, spawnPipe)
import XMonad.Util.NamedWindows (getName)
import XMonad.Hooks.DynamicLog
import qualified XMonad.StackSet as W

import GHC.IO.Handle

-- polybar configuration
polybar = "~/.config/polybar/launch.sh"

polybarSetup :: IO ()
polybarSetup = do
   forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> do
     safeSpawn "mkfifo" ["/tmp/" ++ file]

polybarLogHook = do
  winset <- gets windowset
  title <- maybe (return "") (fmap show . getName) . W.peek $ winset
  let currWs = W.currentTag winset
  let wss = map W.tag $ W.workspaces winset
  let wsStr = join $ map (fmt currWs) $ sort' wss

  io $ appendFile "/tmp/.xmonad-title-log" (title ++ "\n")
  io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr ++ "\n")

  where fmt currWs ws
          | currWs == ws = "[" ++ ws ++ "]"
          | otherwise    = " " ++ ws ++ " "
        sort' = sortBy (compare `on` (!! 0))

-- xmobar
xmobar = "xmobar"

xmobarSetup :: IO Handle
xmobarSetup = spawnPipe "xmobar"

xmobarLogHook xmproc =
  dynamicLogWithPP xmobarPP { ppOutput = \x -> hPutStrLn xmproc x
                            , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                            , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                            -- , ppHidden = xmobarColor "#82AAFF" "" . wrap " " " "   -- Hidden workspaces in xmobar
                            -- , ppHiddenNoWindows = xmobarColor "#F07178" ""        -- Hidden workspaces (no windows)
                            , ppTitle = xmobarColor "#d0d0d0" "" . shorten 80     -- Title of active window in xmobar
                            , ppSep =  "<fc=#9AEDFE> : </fc>"                     -- Separators in xmobar
                            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                            , ppExtras  = [windowCount]                           -- # of windows current workspace
                            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                            }
  where windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
