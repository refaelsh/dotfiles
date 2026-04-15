# modules/programs/bash.nix
# Dendritic NixOS module – pure Lassulus/wrappers style (no Home-Manager, ever)
# Drop this entire file in place of your current one. Rebuild → clean 🏠 λ + full Dracula syntax highlighting in every kitty.

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

        # blesh = ble.sh (pulled via your flake inputs)
        blesh.enable = true;

        interactiveShellInit = ''
          # ── Core shell options (kept exactly as you had them)
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # ── Proper ble.sh initialization (this was the missing piece)
          [[ $- == *i* ]] && source "$(blesh-share)/ble.sh" --attach=none

          # ── FULL DRACULA THEME FOR BLE.SH (only valid faces for your version)
          if [[ -n $BLE_VERSION ]]; then
            ble-face -s syntax_command            'fg=#bd93f9'        # purple commands
            ble-face -s command_keyword           'fg=#ff79c6'        # pink keywords
            ble-face -s syntax_function_name      'fg=#50fa7b,bold'   # green functions
            ble-face -s syntax_quoted             'fg=#f1fa8c'        # yellow strings
            ble-face -s syntax_quotation          'fg=#f1fa8c'        # quoted strings
            ble-face -s syntax_expr               'fg=#8be9fd'        # cyan expressions
            ble-face -s syntax_varname            'fg=#ff5555'        # red variables
            ble-face -s syntax_history_expansion  'fg=#6272a4'        # gray history
            ble-face -s syntax_comment            'fg=#6272a4'        # comments
            ble-face -s auto_complete             'fg=#6272a4'        # subtle suggestions
          fi

          # Your custom prompt (🏠 λ) – Dracula-accented truecolor
          PS1='\[\e[38;2;139;233;253m\]🏠\[\e[0m\] \[\e[38;2;255;184;108m\]λ\[\e[0m\] '

          # ── Finally attach ble.sh (activates syntax highlighting + faces)
          [[ ${BLE_VERSION-} ]] && ble-attach
        '';
      };
    };
}
