# modules/programs/bash.nix
# Dendritic NixOS module – pure Lassulus/wrappers style (no Home-Manager, ever)
# Drop this entire file in place of your current one. Rebuild → clean 🏠 λ + full Dracula in every kitty.

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

          # ── FULL DRACULA THEME FOR BLE.SH (truecolor hex – matches dracula/kitty exactly)
          if [[ -n $BLE_VERSION ]]; then
            # Syntax highlighting (updated names that actually exist in current blesh)
            ble-face -s syntax_command            'fg=#bd93f9'     # purple
            ble-face -s syntax_keyword            'fg=#ff79c6'     # pink
            ble-face -s syntax_function_name      'fg=#50fa7b,bold' # green
            ble-face -s syntax_quoted             'fg=#f1fa8c'     # yellow
            ble-face -s syntax_string             'fg=#f1fa8c'     # yellow
            ble-face -s syntax_expr               'fg=#8be9fd'     # cyan
            ble-face -s syntax_varname            'fg=#ff5555'     # red
            ble-face -s syntax_history_expansion  'fg=#6272a4'     # comment gray
            ble-face -s command                   'fg=#bd93f9,bold'

            # Prompt & UI elements
            ble-face -s prompt_char               'fg=#ffb86c,bold' # orange λ
            ble-face -s prompt_char_over          'fg=#ff5555'      # red when invalid

            # Extra polish (optional but nice with Dracula)
            ble-face -s auto_complete             'fg=#6272a4'
            ble-face -s menu                      'fg=#f8f8f2,bg=#44475a'
            ble-face -s menu_active               'fg=#f8f8f2,bg=#bd93f9'
          fi

          # Your custom prompt (🏠 λ) – now with a tiny Dracula accent
          PS1='\[\e[38;2;139;233;253m\]🏠\[\e[0m\] \[\e[38;2;255;184;108m\]λ\[\e[0m\] '
        '';
      };
    };
}
