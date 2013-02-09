import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.Tabbed
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Hooks.ManageHelpers
import XMonad.Actions.SpawnOn
import XMonad.Util.Run(spawnPipe)
import qualified XMonad.StackSet as W


myStartupHook = return ()
-- myStartupHook = do
--   spawnOn "1:web" "google-chrome"
--   spawnOn "1:web" "urxvt -e 'mosh tlk'"
--   spawnOn "2:term" "urxvt"
--   spawnOn "3:mutt" "urxvt -e 'mutt'"

myManageHook = manageDocks <+> composeAll
  [ resource  =? "desktop_window"       --> doIgnore
  , resource  =? "www.grooveshark.com"  --> doShift "8:music"
  , className =? "VirtualBox"           --> doShift "4:vm"
  , className =? "Thunar"               --> doFloat
  , className =? "Qbittorrent"          --> doShift "9:torrent"
  , className =? "Google-chrome"        --> doShift "1:web"
  , title     =? "mutt"                 --> doShift "3:mutt"
  , isFullscreen                        --> (doF W.focusDown <+> doFullFloat)
  ]

-- "avoidStruts" make space for the status bar
-- "smartBorders" only display borders if there is more than one window
-- "noBorders"
myLayout = smartBorders(avoidStruts(
  -- Make tiles mouse resizable
  -- "BordersDragger" remove gap between tiles
  mouseResizableTile { draggerType = BordersDragger } |||
  -- Tabs
  tabbed shrinkText defaultTheme |||
  -- Fullscreen
  noBorders(Full)))

myKeyBindings = [
   -- Toggle status bar
   ((mod4Mask, xK_b), sendMessage ToggleStruts)
  ]

main = do
  mobar <- spawnPipe "xmobar"
  xmonad =<< xmobar defaults

defaults = defaultConfig {
    terminal           = "urxvt"
  , modMask            = mod4Mask
  , borderWidth        = 1
  , focusFollowsMouse  = True
  , focusedBorderColor = "#ff0000"
  , normalBorderColor  = "#000000"
  , workspaces         = ["1:web","2:term","3:mutt","4:vm","5:media", "6", "7", "8:music", "9:torrent"]
  , manageHook         = myManageHook
  , startupHook        = myStartupHook
  , layoutHook         = myLayout
  , handleEventHook    = docksEventHook
}
