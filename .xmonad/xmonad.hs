import XMonad
import XMonad.Hooks.DynamicLog -- ?
import XMonad.Hooks.ManageHelpers --
import XMonad.Hooks.ManageDocks -- Manage xmobar
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace (onWorkspace) -- set workspace layouts
import XMonad.Layout.LayoutCombinators hiding ((|||)) -- ?
import XMonad.Actions.SpawnOn -- Spawn on specified workspace
import qualified XMonad.StackSet as W -- ?
import XMonad.Util.Run(spawnPipe) -- Spawn
import XMonad.Util.EZConfig(additionalKeys) -- Key bindings

myModKey = mod1Mask -- Set modifier key to alt (default)

myStartupHook = return ()
-- myStartupHook = do
--   spawnOn "1:web" "google-chrome"
--   spawnOn "1:web" "urxvt -e 'mosh tlk'"
--   spawnOn "2:term" "urxvt"
--   spawnOn "3:mutt" "urxvt -e 'mutt'"

myManageHook =
  (doF W.swapDown) -- Keep master position when opening new tiles
  <+> manageDocks -- Manage xmobar
  <+> composeAll -- Set custom manage hooks
    [ resource  =? "desktop_window"       --> doIgnore
    , resource  =? "www.grooveshark.com"  --> doShift "8:music"
    , className =? "VirtualBox"           --> doShift "4:vm"
    , className =? "Thunar"               --> doFloat
    , className =? "Transmission-gtk"     --> doShift "9:torrent"
    , className =? "Google-chrome"        --> doShift "1:web"
    , title     =? "mutt"                 --> doShift "3:mutt"
    , isFullscreen                        --> (doF W.focusDown <+> doFullFloat)
    ]

-- The default layout
--
-- * "avoidStruts" make space for the status bar
-- * "smartBorders" only display borders if there is more than one window
-- * "BordersDragger" remove gap between tiles
defaultLayout = smartBorders $ avoidStruts (
  -- Master window on the left and remaining tiled on the right side.
      mouseResizableTile { draggerType = BordersDragger, masterFrac = masterFraction }
  -- Master window on top and remaining tiled at the bottom.
  ||| Mirror (ResizableTall 1 (3/100) (masterFraction) [])
  -- Fullscreen
  ||| noBorders (Full))

  where
    masterFraction = 2/3

-- Fixed layouts
videoLayout = avoidStruts $ noBorders (Full)
muttLayout = smartBorders $ avoidStruts $ Mirror (ResizableTall 1 (3/100) (2/3) [])

-- Attach the layouts
myLayout =
    onWorkspace "3:mutt" muttLayout
  $ onWorkspace "7:video" videoLayout
  $ defaultLayout

-- Key bindings
-- Some are deafults, but I want to have them documented
myKeyBindings = [
    -- Toggle xmobar.
      ((myModKey, xK_b),               sendMessage ToggleStruts)
    -- Use history aware dmenu wrapper.
    , ((myModKey, xK_p),               spawn "exe=`dmenu_path_c | yeganesh` && eval \"exec $exe\"")
    -- Take screenshot and upload to imgur
    , ((myModKey .|. shiftMask, xK_p), spawn "google-chrome $(scrot -e 'imgurbash $f 2>/dev/null')")
    -- Close focused window.
    , ((myModKey .|. shiftMask, xK_c), kill)
    -- Cycle through available layouts.
    , ((myModKey, xK_space),           sendMessage NextLayout)
    -- Resize windows to correct size.
    , ((myModKey, xK_n),               refresh)
    -- Move focus between windows.
    , ((myModKey, xK_Tab),             windows W.focusDown)
    , ((myModKey, xK_j),               windows W.focusDown)
    , ((myModKey, xK_k),               windows W.focusUp)
    , ((myModKey, xK_m),               windows W.focusMaster)
    -- Swap the focused window.
    , ((myModKey, xK_Return),          windows W.swapMaster)
    , ((myModKey .|. shiftMask, xK_j), windows W.swapDown)
    , ((myModKey .|. shiftMask, xK_k), windows W.swapUp)
    -- Shrink/Expand master area.
    , ((myModKey .|. shiftMask, xK_h), sendMessage Shrink) -- Why doesnt this work without shiftmask?
    , ((myModKey .|. shiftMask, xK_l), sendMessage Expand)
    -- Push window back into tilling.
    , ((myModKey, xK_t),               withFocused $ windows . W.sink)
    -- Change the number of windows in the master area.
    , ((myModKey, xK_comma),           sendMessage (IncMasterN 1))
    , ((myModKey, xK_period),          sendMessage (IncMasterN (-1)))
    -- Restart xmonad.
    , ((myModKey, xK_q),               restart "xmonad" True)
  ]

defaults = defaultConfig {
    terminal           = "urxvt"
  , modMask            = myModKey
  , borderWidth        = 1
  , focusFollowsMouse  = True
  , focusedBorderColor = "#ff0000"
  , normalBorderColor  = "#000000"
  , workspaces         = ["1:web","2:term","3:mutt","4:vm","5:media", "6", "7:video", "8:music", "9:torrent"]
  , manageHook         = myManageHook
  , startupHook        = myStartupHook
  , layoutHook         = myLayout
  , handleEventHook    = docksEventHook
} `additionalKeys` myKeyBindings

-- Startup
main = do
  mobar <- spawnPipe "xmobar"
  xmonad =<< xmobar defaults
