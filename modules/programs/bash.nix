# modules/programs/bash.nix
# Dendritic NixOS module – pure Lassulus/wrappers style (no Home-Manager, ever)
# Drop this entire file in place of your current one. Rebuild → clean 🏠 λ + diagnostics in every kitty.

{ lib, pkgs, ... }:
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

        # blesh = ble.sh (we take full control – official module disabled)
        blesh.enable = false;

        interactiveShellInit = lib.mkForce ''
          # ── Core shell options (kept exactly as you had them)
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # ── Proper ble.sh initialization
          if [[ $- == *i* ]]; then
            source "${pkgs.blesh}/share/blesh/ble.sh" --attach=none
          fi

          # ── Attach first, then configure (this order is required for 0.4.0-devel3)
          [[ ''${BLE_VERSION-} ]] && ble-attach

          # ── FULL DRACULA THEME + FORCE syntax engine on
          if [[ -n ''${BLE_VERSION-} ]]; then
            bleopt highlight_syntax=1
            bleopt highlight_filename=1
            bleopt highlight_variable=1

            # Syntax highlighting – Dracula truecolor hex
            ble-face -s syntax_default            'fg=#f8f8f2'
            ble-face -s syntax_command            'fg=#bd93f9'
            ble-face -s command_keyword           'fg=#ff79c6'
            ble-face -s syntax_function_name      'fg=#50fa7b,bold'
            ble-face -s syntax_quoted             'fg=#f1fa8c'
            ble-face -s syntax_quotation          'fg=#f1fa8c'
            ble-face -s syntax_expr               'fg=#8be9fd'
            ble-face -s syntax_varname            'fg=#ff5555'
            ble-face -s syntax_history_expansion  'fg=#6272a4'
            ble-face -s syntax_comment            'fg=#6272a4'
            ble-face -s auto_complete             'fg=#6272a4'

            # Extra polish
            ble-face -s syntax_brace              'fg=#bd93f9,bold'
            ble-face -s syntax_delimiter          'fg=#f8f8f2,bold'
            ble-face -s syntax_tilde              'fg=#8be9fd,bold'
          fi

          # ── Your custom prompt (🏠 λ) – set LAST
          PS1='\[\e[38;2;139;233;253m\]🏠\[\e[0m\] \[\e[38;2;255;184;108m\]λ\[\e[0m\] '

          # ── DIAGNOSTICS (remove after we fix it)
          echo "=== BLE HIGHLIGHT DIAGNOSTICS ==="
          echo "highlight_syntax   = $(bleopt highlight_syntax 2>/dev/null || echo 'NOT SET')"
          echo "highlight_filename = $(bleopt highlight_filename 2>/dev/null || echo 'NOT SET')"
          echo "highlight_variable = $(bleopt highlight_variable 2>/dev/null || echo 'NOT SET')"
          echo "BLE_VERSION        = ''${BLE_VERSION-}"
          echo "=== END DIAGNOSTICS ==="
        '';
      };
    };
}
