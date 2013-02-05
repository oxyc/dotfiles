import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Fullscreen
import XMonad.Util.Run(spawnPipe)

myStartupHook = return ()

myManageHook = composeAll
  [ resource  =? "desktop_window" --> doIgnore
  , className =? "VirtualBox"     --> doShift "4:vm"
  ]

main = do
  mobar <- spawnPipe "xmobar"
  xmonad =<< xmobar defaults

defaults = defaultConfig {
    terminal         = "urxvt"
  -- , focusFollowMouse = myFocusFollowMouse
  , modMask          = mod4Mask
  , borderWidth      = 1
  , workspaces       = ["1:term","2:web","3:code","4:vm","5:media", "6", "7", "8", "9"]
  -- , layoutHook       = smartBorders
  , manageHook       = myManageHook
  , startupHook      = myStartupHook
}

-- myTerminal = "urxvt"
-- myModMask = mod4Mask
-- myBorderWidth = 1
-- myWorkspaces = 
-- 
-- myFocusFollowsMouse :: Bool
-- myFocusFollowsMouse = True
-- 
-- myStartupHook = return ()
-- 
-- myManageHook = composeAll
--   [ resource  =? "desktop_window" --> doIgnore
--   , className =? "VirtualBox"     --> doShift "4:vm"
--   , isFullscreen --> (doF W.focusDown <+> doFullFloat)]
-- 
-- main = do
--   xmproc <- spawnPipe "xmobar"
--   xmonad $ defaults {
--       manageHook = manageDocks <+> myManageHook
--   }
-- 
-- defaults = defaultConfig {
--     terminal         = myTerminal
--   , focusFollowMouse = myFocusFollowMouse
--   , modMask          = myModMask
--   , borderWidth      = myBorderWidth
--   , workspaces       = myWorkspaces
--   , layoutHook       = smartBorders
--   , manageHook       = myManageHook
--   , startupHook      = myStartupHook
-- }
-- 
