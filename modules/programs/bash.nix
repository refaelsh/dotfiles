{ lib, ... }:

{

  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Re-read repo right now: https://github.com/refaelsh/dotfiles/blob/master/modules/programs/bash.nix
  # (still the minimal bind+shopt version – no Lassulus wrappers ever needed here)
  # blesh.enable = true; + direct ble-face after the module’s mkBefore source = perfect timing

  flake.nixosModules.bash =
    { pkgs, lib, ... }:

    {
      programs.bash = {
        enable = true;
        blesh.enable = true;
        interactiveShellInit = ''
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # Dracula theme for ble.sh (blesh) – direct ble-face after blesh is fully loaded
          # (NixOS blesh module sources ble.sh *first* via mkBefore → faces are defined)
          # No ~/.blerc at all = no more early-sourcing “face not found” spam
          # Exact Dracula palette from https://draculatheme.com
          if [[ -n ''${BLE_VERSION-} ]]; then
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
          fi
        '';
      };
    };

}
