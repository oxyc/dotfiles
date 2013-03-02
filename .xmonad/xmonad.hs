import XMonad

import Data.List -- Clickable workspaces
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Actions.SpawnOn -- Spawn on specified workspace
import XMonad.Util.EZConfig(additionalKeys) -- Key bindings
import XMonad.Util.Run(spawnPipe) -- Spawn
import qualified XMonad.StackSet as W -- Swapping

-- dzen
import XMonad.Hooks.DynamicLog hiding (xmobar, xmobarPP, xmobarColor, sjanssenPP, byorgeyPP)
import XMonad.Hooks.ManageDocks
import System.IO (hPutStrLn)

-- layouts
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace (onWorkspace) -- set workspace layouts
import XMonad.Layout.LayoutCombinators hiding ((|||)) -- ?

import XMonad.Hooks.SetWMName -- Fix for Java GUIs
import XMonad.Hooks.EwmhDesktops

-- Settings

myModKey          = mod1Mask
background        = "#111111"
foregroundActive  = "#ebac54"
foreground        = "#aaaaaa"
font              = "InconsolataForPowerline-10" -- requires dmenu with xft patch

-- dzen font is set in .Xresources
leftBar           = "dzen2 -x 0 -y 0 -w 1200 -ta l -bg " ++ background ++ " -fg "++ foreground
rightBar          = "conky -qc /home/oxy/.xmonad/conky | dzen2 -x 1200 -y 0 -ta r -w 400"
dmenuFlags        = "-nb '" ++ background
                    ++ "' -nf '" ++ foreground
                    ++ "' -sb '" ++ foregroundActive
                    ++ "' -sf '" ++ background
                    ++ "' -fn '" ++ font
                    ++ "'"
yeganesh          = "exe=\"$(dmenu_path_c | yeganesh -- " ++ dmenuFlags ++ ")\" && eval \"exec $exe\""

includeIcon x     = "^i(/home/oxy/.xmonad/icons/" ++ x ++ ".xbm)"

myWorkspaces = clickable $
  [ includeIcon ("arch") ++ " web"
  , includeIcon ("fs_01")
  , "3"
  , "4"
  , "5"
  , includeIcon ("mail")
  , includeIcon ("dish")
  , includeIcon ("note")
  , includeIcon ("net_down_02")
  ]
  -- Clickable workspaces
  where clickable l = ["^ca(1,xdotool key alt+" ++ show (n) ++ ")" ++ ws ++ "^ca()" |
                        (i,ws) <- zip [1..] l,
                        let n = i ]

myManageHook =
  manageDocks -- Manage dzen
  <+> composeAll -- Set custom manage hooks
    [ resource  =? "desktop_window"       --> doIgnore
    , resource  =? "www.grooveshark.com"  --> doShift (myWorkspaces !! 7)
    , className =? "VirtualBox"           --> doShift (myWorkspaces !! 6)
    , className =? "Thunar"               --> doFloat
    , className =? "Transmission-gtk"     --> doShift (myWorkspaces !! 8)
    , className =? "Google-chrome"        --> doShift (myWorkspaces !! 0)
    , title     =? "mutt"                 --> doShift (myWorkspaces !! 5)
    -- Make fullscreen and dont swap tiles.
    , isFullscreen                        --> (doFullFloat <+> doF W.swapUp)
    -- Keep master position when opening new tiles.
    , isFullscreen =? False               --> (doF W.swapDown)
    ]

----

-- Always keep mutt tile wide and on top.
muttLayout = smartBorders $ avoidStruts $ Mirror (ResizableTall 1 (3/100) (2/3) [])

-- avoidStruts: make space for the status bar
-- smartBorders: only display borders if there is more than one window
-- BordersDragger: remove gap between tiles
myLayoutHook =
    onWorkspace (myWorkspaces !! 5) muttLayout

  $ smartBorders (
  -- Master window on the left and remaining tiled on the right side.
      avoidStruts (mouseResizableTile { draggerType = BordersDragger, masterFrac = masterFraction })
  -- Master window on top and remaining tiled at the bottom.
  ||| avoidStruts (Mirror (ResizableTall 1 (3/100) (masterFraction) []))
  -- Fullscreen
  ||| noBorders (Full))

  where
    masterFraction = 2/3

----

myLogHook h = dynamicLogWithPP $ defaultPP {
    ppCurrent           = dzenColor foregroundActive background . pad
  , ppVisible           = dzenColor "#ff00ff" background . pad
  , ppHidden            = dzenColor "#eeeee" background . pad
  , ppHiddenNoWindows   = dzenColor "#333333" background . pad
  , ppUrgent            = dzenColor "#ff0000" background . pad
  , ppWsSep             = ""
  , ppSep               = "  \57521  " -- 
  , ppLayout            = dzenColor "#666666" background
                          . wrap "^ca(1,xdotool key alt+space)" "^ca()" -- toggle layout
                          . (\x -> case x of
                              "MouseResizableTile"   -> includeIcon("layout-tall")
                              "Mirror ResizableTall" -> includeIcon("layout-mtall")
                              "Full"                 -> includeIcon("full")
                              _                      -> x
                          )
  , ppTitle             = dzenColor foregroundActive background
                          . wrap "^ca(1,xdotool key alt+k)" "^ca()" -- change focus
                          . dzenEscape
  , ppOutput            = hPutStrLn h
}

----

-- Some are deafults, but I want to have them documented
myKeyBindings = [
    -- Toggle xmobar.
      ((myModKey, xK_b),               sendMessage ToggleStruts)
    -- Take a screenshot
    , ((0, xK_Print),                  spawn "scrot -e 'mv $f ~/pictures/screenshots/'")
    -- Take screenshot and upload to imgur
    , ((myModKey, xK_Print),           spawn "google-chrome $(scrot -e 'imgurbash $f 2>/dev/null')")
    -- Use history aware dmenu wrapper.
    , ((myModKey, xK_p),               spawn yeganesh)
    -- launch file browser
    , ((myModKey, xK_o),               spawn "thunar")
    -- Close focused window.
    , ((myModKey, xK_c), kill)
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
    , ((myModKey, xK_h),               sendMessage Shrink)
    , ((myModKey, xK_l),               sendMessage Expand)
    -- Shrink/Expand slave area.
    , ((myModKey, xK_u),               sendMessage ShrinkSlave)
    , ((myModKey, xK_i),               sendMessage ExpandSlave)
    -- Push window back into tilling.
    , ((myModKey, xK_t),               withFocused $ windows . W.sink)
    -- Change the number of windows in the master area.
    , ((myModKey, xK_comma),           sendMessage (IncMasterN 1))
    , ((myModKey, xK_period),          sendMessage (IncMasterN (-1)))
    -- Restart xmonad.
    , ((mod1Mask, xK_q),               spawn "killall dzen2 conky; cd ~/.xmonad; ghc -threaded xmonad.hs; mv xmonad xmonad-x86_64-linux; xmonad --restart" )
    , ((mod1Mask .|. shiftMask, xK_q), spawn "killall dzen2 conky; cd ~/.xmonad; ghc -threaded xmonad.hs; mv xmonad xmonad-x86_64-linux; xmonad --restart" )
  ]

-- Startup
main = do
  dzenLeftBar <- spawnPipe leftBar
  dzenRightBar <- spawnPipe rightBar
  xmonad $ ewmh $ withUrgencyHook NoUrgencyHook $ defaultConfig {
      terminal           = "urxvt"
    , modMask            = myModKey
    , borderWidth        = 1
    , focusFollowsMouse  = True
    , focusedBorderColor = "#ff0000"
    , normalBorderColor  = "#000000"
    , workspaces         = myWorkspaces
    , manageHook         = myManageHook
    , logHook            = myLogHook dzenLeftBar
    , layoutHook         = myLayoutHook
    , handleEventHook    = docksEventHook
    , startupHook        = setWMName "LG3D" -- Fix Java GUI
  } `additionalKeys` myKeyBindings
