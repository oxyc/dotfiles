import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Fullscreen
import XMonad.Actions.SpawnOn
import XMonad.Util.Run(spawnPipe)
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders

myStartupHook = return ()
-- myStartupHook = do
--   spawnOn "1:web" "google-chrome"
--   spawnOn "1:web" "urxvt -e 'mosh tlk'"
--   spawnOn "2:term" "urxvt"
--   spawnOn "3:mutt" "urxvt -e 'mutt'"

myManageHook = composeAll
  [ resource  =? "desktop_window" --> doIgnore
  , className =? "VirtualBox"     --> doShift "4:vm"
  , className =? "Thunar"         --> doFloat
  , className =? "Qbittorrent"    --> doShift "9:torrent"
  , className =? "Google-chrome"  --> doShift "1:web"
  , title     =? "mutt"           --> doShift "3:mutt"
  ]

myLayout = mouseResizableTile {
    draggerType = BordersDragger -- Remove gap between tiles
}

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
  , workspaces         = ["1:web","2:term","3:mutt","4:vm","5:media", "6", "7", "8", "9:torrent"]
  , manageHook         = myManageHook
  , startupHook        = myStartupHook
  , layoutHook         = smartBorders $ myLayout
}
