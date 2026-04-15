{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # interactiveShellInit is now enough because Kitty launches with -i
  # + Dracula theme for blesh (syntax highlighting) to match kitty + starship
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;

        blesh.enable = true;

        interactiveShellInit = ''
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # ── Dracula theme for blesh (exact palette from your starship/kitty) ──
          if [[ -n ''${BLE_VERSION-} ]]; then
            # Base colors
            ble-face -s auto_complete          'fg=#6272a4,bg=#44475a'
            ble-face -s syntax_default         'fg=#f8f8f2'
            ble-face -s syntax_command         'fg=#50fa7b'
            ble-face -s syntax_keyword         'fg=#ff79c6,bold'
            ble-face -s syntax_string          'fg=#f1fa8c'
            ble-face -s syntax_varname         'fg=#bd93f9'
            ble-face -s syntax_error           'fg=#ff5555'
            ble-face -s syntax_function        'fg=#8be9fd'
            ble-face -s syntax_comment         'fg=#6272a4'
            ble-face -s syntax_quoted          'fg=#f1fa8c'
            ble-face -s syntax_expression      'fg=#ffb86c'
            ble-face -s syntax_history         'fg=#bd93f9'

            # Prompt / cursor / other elements (matches starship Dracula)
            ble-face -s prompt_char            'fg=#f8f8f2'
            ble-face -s prompt_status          'fg=#ff5555'
            ble-face -s prompt_info            'fg=#bd93f9'
          fi
        '';
      };
    };
}
