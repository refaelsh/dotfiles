# modules/programs/bash.nix
# Dendritic NixOS module – pure Lassulus/wrappers style (no Home-Manager, ever)
# Drop this entire file in place of your current one. Rebuild → clean 🏠 λ + FULL Dracula syntax highlighting in every kitty.

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

          # ── Proper ble.sh initialization (exact from upstream README for 0.4.0-devel3)
          if [[ $- == *i* ]]; then
            source "${pkgs.blesh}/share/blesh/ble.sh" --attach=none
          fi

          # ── FULL DRACULA THEME FOR BLE.SH + enable syntax engine
          if [[ -n ''${BLE_VERSION-} ]]; then
            # Enable the syntax highlighter (this was the missing piece)
            bleopt highlight_syntax=1
            bleopt highlight_filename=1
            bleopt highlight_variable=1

            # Syntax highlighting – Dracula truecolor hex (all your faces are already confirmed working)
            ble-face -s syntax_default            'fg=#f8f8f2'        # normal text
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

            # Extra Dracula polish (matches the faces you already see in ble-face)
            ble-face -s syntax_brace              'fg=#bd93f9,bold'
            ble-face -s syntax_delimiter          'fg=#f8f8f2,bold'
            ble-face -s syntax_tilde              'fg=#8be9fd,bold'
          fi

          # Your custom prompt (🏠 λ) – Dracula-accented truecolor
          PS1='\[\e[38;2;139;233;253m\]🏠\[\e[0m\] \[\e[38;2;255;184;108m\]λ\[\e[0m\] '

          # ── Finally attach ble.sh (activates syntax highlighting + faces)
          [[ ''${BLE_VERSION-} ]] && ble-attach
        '';
      };
    };
}
