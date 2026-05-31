import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.SpawnOn
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Layout.NoBorders
import XMonad.Layout.ToggleLayouts
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.Hacks qualified as Hacks
import XMonad.Util.SpawnOnce

myTerminal :: String
myTerminal = "ghostty"

myStartupHook :: X ()
myStartupHook = do
  -- Links the user keyring to the session keyring.
  -- Important for ssh-agent, Bitwarden, and other keyring-dependent tools.
  -- "2>/dev/null || true" prevents failure if the link already exists.
  spawn "keyctl link @u @s 2>/dev/null || true"
  spawnOnce "killall trayer; trayer --height 26 --edge bottom --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x282a36"
  spawnOnce "clipmenud"
  spawnOnce "numlockx on"
  spawnOnce "setxkbmap -layout us,il -option grp:alt_shift_toggle"
  spawnOnce "kbdd"
  -- Removed: two amixer calls that did -5% then immediately +5% on every
  -- startup (and used `spawn` instead of `spawnOnce`). They had no effect.
  spawnOnOnce "1" "brave"
  -- Commented out (discord package is disabled in one-liners.nix, causing silent launch failure).
  -- spawnOnOnce "8" "discord"
  spawnOnOnce "9" "signal-desktop"
  -- Workspace 0: Editor (with file tree) + terminal
  spawnOnOnce "0" "cd ~/repos/dotfiles/ && neovide flake.nix -- -c \"NvimTreeOpen\""
  spawnOnOnce "0" myTerminal

myXmobarPP :: PP
myXmobarPP =
  def
    { ppCurrent = xmobarColor "#ff79c6" "",
      ppVisible = xmobarColor "#ff79c6" "", -- . clickable
      ppHidden = xmobarColor "#bd93f9" "", -- . wrap
      ppTitle = xmobarColor "#e6e6e6" "" . shorten 60,
      ppSep = "<fc=" ++ "#4d4d4d" ++ "> <fn=1>|</fn> </fc>",
      ppUrgent = xmobarColor "#ff5555" "" . wrap "!" "!",
      ppOrder = \(ws : l : t : ex) -> [ws]
    }

main :: IO ()
main =
  xmonad
    . ewmhFullscreen
    . ewmh
    . docks
    . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
    $ myConfig

myLayoutHook = avoidStruts $ smartBorders $ toggleLayouts Full (Tall 1 (3 / 100) (1 / 2))

myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

myConfig =
  def
    { modMask = mod4Mask,
      workspaces = myWorkspaces,
      terminal = myTerminal,
      startupHook = myStartupHook,
      manageHook = insertPosition End Newer <> (manageSpawn <+> manageHook def),
      layoutHook = myLayoutHook,
      handleEventHook = swallowEventHook (className =? "neovide") (return True) <> Hacks.trayerPaddingXmobarEventHook,
      borderWidth = 2,
      focusedBorderColor = "#bd93f9",
      normalBorderColor = "#44475a"
    }
    `additionalKeysP` [ ("M-<Return>", spawn myTerminal),
                        ("M-d", shellPrompt def {alwaysHighlight = True, height = 30, borderColor = "#BD93F9", fgColor = "#F8F8F2", bgColor = "#282A36", fgHLight = "#F8F8F2", bgHLight = "#6272A4"}),
                        ("M-S-q", kill),
                        ("M-f", sendMessage (Toggle "Full") <> sendMessage ToggleStruts),
                        ("M-0", windows $ W.greedyView "0"),
                        ("M-S-0", windows $ W.shift "0"),
                        ("M-<Left>", windowGo L False),
                        ("M-<Right>", windowGo R False),
                        ("M-<Up>", windowGo U False),
                        ("M-<Down>", windowGo D False),
                        ("M-S-<Left>", windowSwap L False),
                        ("M-S-<Right>", windowSwap R False),
                        ("M-S-<Up>", windowSwap U False),
                        ("M-S-<Down>", windowSwap D False),
                        ("<Print>", spawn "flameshot gui"),
                        ("M1-c", spawn "clipmenu -nf '#F8F8F2' -nb '#282A36' -sb '#6272A4' -sf '#F8F8F2' -fn 'monospace-10'"),
                        ("M-<F11>", spawn "amixer set Master 5%-"),
                        ("M-<F12>", spawn "amixer set Master 5%+")
                      ]
    `removeKeysP` [ "M-S-<Return>"
                  , "M-p"
                  , "M-S-c"
                  , "M-<Tab>"
                  , "M-S-<Tab>"
                  , "M-j"
                  , "M-k"
                  , "M-m"
                  , "M-l"
                  ]
