{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # interactiveShellInit is now enough because Kitty launches with -i
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;

        blesh.enable = true;

        interactiveShellInit = ''
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # === Dracula Theme for ble.sh (embedded inline – no external .blerc or misc/ files) ===
          # All changes stay 100% inside this single bash.nix file as requested.
          # Uses exact 24-bit Dracula palette to match Kitty's Dracula theme perfectly.
          if [[ -n "''${BLE_VERSION-}" ]]; then
            bleopt color_scheme=  # disable any built-in scheme

            # Base colors
            ble-face -s bg                    bg=#282a36
            ble-face -s fg                    fg=#f8f8f2
            ble-face -s comment               fg=#6272a4

            # Syntax highlighting
            ble-face -s syntax_comment        fg=#6272a4
            ble-face -s syntax_keyword        fg=#ff79c6 bold
            ble-face -s syntax_command        fg=#ff79c6
            ble-face -s syntax_function       fg=#50fa7b
            ble-face -s syntax_variable       fg=#f1fa8c
            ble-face -s syntax_delimiter      fg=#bd93f9
            ble-face -s syntax_string         fg=#f1fa8c italic
            ble-face -s syntax_number         fg=#bd93f9
            ble-face -s syntax_quoted         fg=#f1fa8c
            ble-face -s syntax_glob           fg=#ffb86c
            ble-face -s syntax_bracket        fg=#8be9fd

            # UI faces
            ble-face -s auto_complete         fg=#6272a4 bg=#44475a
            ble-face -s auto_complete_menu    fg=#f8f8f2 bg=#44475a
            ble-face -s region                bg=#44475a fg=#f8f8f2
            ble-face -s region_target         bg=#ff79c6 fg=#282a36
            ble-face -s region_match          bg=#8be9fd fg=#282a36
            ble-face -s vim_mode              fg=#ff5555 bold
            ble-face -s vim_insert_mode       fg=#50fa7b bold
            ble-face -s vim_visual_mode       fg=#f1fa8c bold
            ble-face -s prompt                fg=#f8f8f2

            # File / path / command colors
            ble-face -s directory             fg=#8be9fd
            ble-face -s file                  fg=#f8f8f2
            ble-face -s pathname              fg=#8be9fd
            ble-face -s command               fg=#ff79c6
            ble-face -s argument              fg=#ffb86c
            ble-face -s variable              fg=#f1fa8c
          fi
        '';
      };
    };
}
