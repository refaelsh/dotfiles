# xmonad session

LightDM logs `refaelsh` into xmonad. Super+Return opens Ghostty, Super+d opens the shell prompt, Super+Shift+q closes a window, and Print starts Flameshot. dwm is installed as a second session and is not the login session.

## Sub-features

- `session-login` auto-logs `refaelsh` into `none+xmonad` through LightDM. dwm is enabled and is not the default session.
- `session-keys` binds Super+Return, Super+d, Super+Shift+q, Print, and the volume keys.
- `session-startup` starts the tray, notifications, Brave on workspace 1, Signal on workspace 9, and Neovide plus Ghostty on workspace 0.
- `session-terminal` sets the xmonad terminal to Ghostty and configures Ghostty's font, Dracula theme, disabled shell integration, and paste bindings.

## How to get to it (user POV)

- Boot the machine. LightDM signs in `refaelsh` and starts xmonad.
- Press Super+Return for a terminal.
- Press Super+d for the shell prompt.
- Press Super+Shift+q to close a window.
- Press Print for a screenshot.
- Press Super+F11 or Super+F12 to change volume.
- Choose the dwm session from LightDM's session menu when a second window manager is wanted. The automatic login does not choose it.

## Driving it with verify-nixos

Preconditions:

- `verify-nixos launch` printed `ready host=nixos session=none+xmonad user=refaelsh system=x86_64-linux stateVersion=26.05`.
- `verify-nixos doctor` printed `activation=unchanged`.
- The commands below use `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos`.

- **Login session.** Require LightDM, auto-login, xmonad, and a non-default dwm session. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature xmonad-session --artifact session session --python 'd["hostName"]=="nixos" and d["defaultSession"]=="none+xmonad" and d["autoLogin"] is True and d["autoLoginUser"]=="refaelsh" and d["lightdm"] is True and d["xmonad"] is True and d["dwm"] is True and d["user"] is True and d["system"]=="x86_64-linux"'`. `session.out` matches that expression.
- **Keys.** Require Super, the terminal, the prompt, close, screenshot, and volume bindings in the xmonad config string. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature xmonad-session --artifact keys services.xserver.windowManager.xmonad.config --contains 'modMask = mod4Mask' --contains 'myTerminal = "ghostty"' --contains '("M-<Return>", spawn myTerminal)' --contains '("M-d", shellPrompt' --contains '("M-S-q", kill)' --contains '("<Print>", spawn "flameshot gui")' --contains '("M-<F11>", spawn "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-")' --contains '("M-<F12>", spawn "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+")'`. `keys.out` contains each of those literals.
- **Startup clients.** Require the tray, notifications, and workspace clients. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-raw --feature xmonad-session --artifact startup services.xserver.windowManager.xmonad.config --contains 'tint2 -c /home/refaelsh/.config/tint2/tray.tint2rc' --contains 'spawnOnce "dunst"' --contains 'spawnOnce "kbdd"' --contains 'spawnOnOnce "1" "brave"' --contains 'spawnOnOnce "9" "signal-desktop"' --contains 'spawnOnOnce "0" "cd ~/repos/dotfiles/ && neovide flake.nix -- -c \"NvimTreeOpen\""' --contains 'spawnOnOnce "0" myTerminal'`. `startup.out` contains each literal.
- **Ghostty from Super+Return.** Require the wrapped Ghostty settings that the terminal binding launches. Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-query --feature xmonad-session --artifact ghostty ghostty-settings --python 'd["count"]==1 and d["font-family"]==["FiraCode Nerd Font"] and d["font-size"]==[12] and d["theme"]==["Dracula"] and d["shell-integration"]==["none"] and d["keybind"]==["ctrl+shift+c=copy_to_clipboard","ctrl+shift+v=paste_from_clipboard","performable:ctrl+c=copy_to_clipboard","ctrl+v=paste_from_clipboard"]'`. `ghostty.out` matches that expression. Font, size, theme, and shell integration are one-element lists.
- **Activation untouched.** Run `/home/refaelsh/repos/dotfiles/.cursor/skills/verify-nixos/scripts/verify-nixos assert-inactive --feature xmonad-session --artifact activation`. `activation.out` shows the same booted path and the same result-link list as launch.

## Gotchas

- Do not start LightDM, xmonad, or Ghostty from the verification run. The logged-in desktop is the user's session.
- `defaultSession` is `none+xmonad`. `dwm` evaluating to true does not mean dwm is the login session.
- The xmonad config is the Haskell source string. This journey does not compile it. A build would violate the harness.
- Ghostty wrapper settings evaluate as one-element lists because the key-value module type stores every value as a list. Assert the lists.
- Super+Shift+q kills a window. This xmonad config does not bind quit. Do not require a quit key.
- Discord is commented out of startup. Do not require a Discord spawn.
- The brave-browser eval warning on stderr is not a failed key check.
