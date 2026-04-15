# modules/programs/bash.nix
# Dendritic NixOS module – pure Lassulus/wrappers style (no Home-Manager, ever)
# Drop this entire file in place of your current one. Rebuild → clean 🏠 λ + full Dracula + final debug in every kitty.

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

        # Disable the official NixOS blesh module completely
        # (this was the last source of interference)
        blesh.enable = false;

        interactiveShellInit = lib.mkForce ''
          # ── Core shell options (kept exactly as you had them)
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd

          # ── DEBUG: we’ll see exactly what happens now
          echo "=== BLE DEBUG START ==="
          echo "Before sourcing - BLE_VERSION: ''${BLE_VERSION-}"
          echo "blesh path exists: ${pkgs.blesh}/share/blesh/ble.sh"
          echo "=== BLE DEBUG END ==="

          # ── Proper ble.sh initialization (exact recommendation from ble.sh README)
          if [[ $- == *i* ]]; then
            source "${pkgs.blesh}/share/blesh/ble.sh" --attach=none
          fi

          # ── Check if ble.sh actually loaded
          if [[ -n ''${BLE_VERSION-} ]]; then
            echo "✅ ble.sh loaded successfully (version $BLE_VERSION)"

            # ── FULL DRACULA THEME FOR BLE.SH (only valid faces for 0.4.0-devel3)
            ble-face -s syntax_command            'fg=#bd93f9'        # purple commands
            ble-face -s command_keyword           'fg=#ff79c6'        # pink keywords
            ble-face -s syntax_function_name      'fg=#50fa7b,bold'   # green functions
            ble-face -s syntax_quoted             'fg=#f1fa8c'        # yellow strings
            ble-face -s syntax_expr               'fg=#8be9fd'        # cyan expressions
            ble-face -s syntax_varname            'fg=#ff5555'        # red variables
            ble-face -s syntax_history_expansion  'fg=#6272a4'        # gray history
            ble-face -s syntax_comment            'fg=#6272a4'        # comments
            ble-face -s auto_complete             'fg=#6272a4'        # subtle suggestions
          else
            echo "⚠️  WARNING: BLE_VERSION still empty after sourcing"
          fi

          # Your custom prompt (🏠 λ) – Dracula-accented truecolor
          PS1='\[\e[38;2;139;233;253m\]🏠\[\e[0m\] \[\e[38;2;255;184;108m\]λ\[\e[0m\] '

          # ── Finally attach ble.sh (this activates syntax highlighting + faces)
          [[ ''${BLE_VERSION-} ]] && ble-attach
        '';
      };
    };
}
