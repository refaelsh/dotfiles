# modules/programs/bash.nix
# Dendritic NixOS module – pure wrappers style (Lassulus/wrappers philosophy, no Home-Manager ever)
# This is the exact file you can copy/paste over your current modules/programs/bash.nix
# It enables blesh (ble.sh) + your 🏠 λ prompt setup + modern face definitions so the spam disappears forever

{ lib, ... }:
{
  flake.nixosModules.bash =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.bash = {
        enable = true;

        # blesh = ble.sh – the Bash Line Editor (pulled via your flake inputs)
        blesh.enable = true;

        # Everything that used to live in .bashrc / interactive shell
        interactiveShellInit = ''
          # ── Core shell options (kept exactly as you had them)
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # ── Modern ble.sh face definitions (this is what was causing the spam)
          # Old names like syntax_keyword / syntax_string were removed in recent ble.sh
          # These are the current official face names with colors that match your original intent
          ble-face -s syntax-command       'fg=cyan'
          ble-face -s syntax-function-name 'fg=green,bold'
          ble-face -s syntax-quoted        'fg=magenta'
          ble-face -s syntax-expression    'fg=blue'
          ble-face -s history              'fg=gray'
          ble-face -s prompt-char          'fg=yellow,bold'   # your beloved λ

          # Optional extra faces you might want later (uncomment if needed)
          # ble-face -s syntax-var           'fg=orange'
          # ble-face -s command              'fg=cyan,bold'
          # ble-face -s syntax-string        'fg=magenta'   # alias if you still reference old name somewhere

          # Your custom prompt (🏠 λ) – injected here so it works with ble.sh
          # (if you have a separate wrapper for the prompt, it will still compose cleanly)
          PS1='\[\e[1;34m\]🏠\[\e[0m\] \[\e[1;33m\]λ\[\e[0m\] '
        '';

        # Any other global bash settings you already had stay untouched
      };
    };
}
