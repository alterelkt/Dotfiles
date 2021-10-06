-- [Imports] -- |
--------------- V
import Data.Monoid
import System.Exit
import System.IO
import System.Directory

import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.WallpaperSetter
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.NamedScratchpad
import XMonad.Util.SpawnOnce
import XMonad.Util.Ungrab


-- [Workspace] -- |
----------------- V
myWorkspaces    = ["sys","web","code","study","design","chat","multi","vbox","misc"]


-- [Custom Keybindings] -- |
-------------------------- V
mycustomKeys = [
   -- modMask window management
   ("M-f",                     kill),
   -- modMask combinations applications
   ("M-t",                     spawn "alacritty"),
   ("M-b",                     spawn "brave"),
   ("M-s",                     spawn "dmenu_run"),
   -- modMask combinations commands
   ("M-r",                     spawn "alacritty -e bash -i -c ranger"),
   ("M-v",                     spawn "alacritty -e bash -i -c vim"),
   -- modMask combination scripts
   ("M-<F3>",                  spawn "cd $HOME/.userscripts/NightLight/ && ./NightLight.sh"),
   -- Non modMask combinations
   ("<Print>",                 unGrab *> spawn "scrot ~/Pictures/Screenshots/%Y-%m-%d-%T-screenshot.png"),
   -- XF86Keys commands
   ("<XF86MonBrightnessUp>",   spawn "xbacklight -inc 5"),
   ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5"),
   ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 2%+"),
   ("<XF86AudioLowerVolume>",  spawn "amixer set Master 2%-"),
   ("<XF86AudioMute>",         spawn "amixer set Master toggle"),
   -- XF86Keys scripts
   ("<XF86ScreenSaver>",       spawn "cd $HOME/.userscripts/BacklightOnOff/ && ./BacklightOnOff.sh"),
   ("<XF86TouchpadToggle>",    spawn "~/Git/GitHub/WMScripts/touchpadtoggle.sh")
   ]


-- [Layouts] -- |
--------------- V
myLayout = smartBorders $ avoidStruts $ spacingRaw True (Border 4 4 4 4) True (Border 4 4 4 4) True $ tiled ||| noBorders myTabbedLayout
  where
     tiled   = Tall nmaster delta ratio
     nmaster = 1
     ratio   = 1/2
     delta   = 3/100

myTabbedLayout = renamed [Replace "myTabbedLayout"] $ tabbed shrinkText myTabbedTheme
myTabbedTheme = def { fontName = "xft:Ubuntu Mono:pixelsize=16"
                 , activeColor         = "#D5C4A1"
                 , inactiveColor       = "#282828"
                 , activeBorderColor   = "#D5C4A1"
                 , inactiveBorderColor = "#282828"
                 , activeTextColor     = "#282828"
                 , inactiveTextColor   = "#ebdbb2"
                 }


-- [Window rules] -- |
-------------------- V
myManageHook = composeAll
    [ className =? "confirm"        --> doFloat
    , className =? "file_progress"  --> doFloat
    , className =? "dialog"         --> doFloat
    , className =? "download"       --> doFloat
    , className =? "error"          --> doFloat
    , className =? "notification"   --> doFloat
    , className =? "splash"         --> doFloat
    , className =? "toolbar"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , className =? "Conky"          --> doIgnore
    ]


-- [Event handling] -- |
---------------------- V
myEventHook = handleEventHook def <+> fullscreenEventHook


-- [Status bars and logging] -- |
------------------------------- V
myLogHook = return() -- dynamicLogWithPP $  
myXmobarPP =  xmobarPP { ppCurrent = xmobarColor "#FABD2F" "" . wrap "  [" "]  "
            , ppVisible = xmobarColor "#D79921" "" . wrap " " " "
            , ppHidden = xmobarColor "#8EC07C" "" . wrap " '" " "
            , ppHiddenNoWindows = xmobarColor "#83A598" "" . wrap " " " "
            , ppUrgent = xmobarColor "#FB4934" "" . wrap " !" " "
            , ppOrder  = \(ws: _ : _ : _ ) -> [ws]
            }

-- [Startup hook] -- |
-------------------- V
myStartupHook = do
                spawnOnce "~/Git/GitHub/WMScripts/wallpaperslideshow.sh &"
                spawnOnce "picom --experimental-backends --config ~/.config/picom/picom.conf  &"
                spawnOnce "trayer --edge top --align left --SetDockType true --SetPartialStrut true --expand true --width 5 --transparent true --tint 0x282828 --alpha 75 --height 21 --monitor 1 &"
                spawnOnce "nm-applet &"


-- [main] -- |
------------ V
main = xmonad . ewmh =<< statusBar "xmobar -x 1 ~/.config/xmobar/xmobarrc" myXmobarPP toggleStrutsKey myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_a)

myConfig = def {
        borderWidth        = 2,
        normalBorderColor  = "#282828",
        focusedBorderColor = "#ebdbb2",
        focusFollowsMouse  = True,
        modMask            = mod4Mask,
        workspaces         = myWorkspaces,
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    } `additionalKeysP` mycustomKeys
