{ lib, ... }:

{

  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Re-read repo right now: https://github.com/refaelsh/dotfiles/blob/master/modules/programs/bash.nix
  # (current file is still the minimal bind+shopt version – no Lassulus wrappers ever needed here)

  flake.nixosModules.bash =
    { pkgs, lib, ... }:

    {
      programs.bash = {
        enable = true;
        blesh.enable = true;
        interactiveShellInit = ''
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # Dracula theme for ble.sh (blesh) – fixed with function + blehook/attach
          # No heredoc = no more "delimited by end-of-file" or "unexpected end of file" errors
          # Runs AFTER blesh fully initializes (all faces are defined)
          # Exact Dracula palette from https://draculatheme.com
          if [[ -n ''${BLE_VERSION-} ]]; then
            ble_dracula_theme() {
              ble-face -s default             'fg=#f8f8f2,bg=#282a36'
              ble-face -s region              'bg=#44475a,fg=#f8f8f2'
              ble-face -s region_match        'bg=#ff79c6,fg=#282a36'
              ble-face -s command             'fg=#50fa7b,bold'
              ble-face -s builtin             'fg=#50fa7b,bold'
              ble-face -s keyword             'fg=#ff79c6'
              ble-face -s string              'fg=#f1fa8c'
              ble-face -s comment             'fg=#6272a4,italic'
              ble-face -s variable            'fg=#8be9fd'
              ble-face -s function            'fg=#bd93f9'
              ble-face -s error               'fg=#ff5555,bold'
              ble-face -s auto_complete       'fg=#6272a4,bg=#44475a'
              ble-face -s menu                'fg=#f8f8f2,bg=#44475a'
              ble-face -s menu_filter         'fg=#f8f8f2,bg=#44475a'
              ble-face -s menu_match          'fg=#ff79c6,bg=#44475a'
              ble-face -s syntax_error        'fg=#ff5555'
              ble-face -s varname             'fg=#8be9fd'
            }
            blehook/attach ble_dracula_theme
          fi
        '';
      };
    };

}
