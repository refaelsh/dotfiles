# modules/programs/bash.nix
# Dendritic NixOS module – pure Lassulus/wrappers style (no Home-Manager, ever)
# Drop this entire file in place of your current one. Rebuild → clean 🏠 λ in every kitty.

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

          # ── Correct modern ble.sh face definitions (underscores only – this kills all errors)
          ble-face -s syntax_command            'fg=cyan'
          ble-face -s syntax_function_name      'fg=green,bold'
          ble-face -s syntax_quoted             'fg=magenta'
          ble-face -s syntax_expr               'fg=blue'
          ble-face -s syntax_history_expansion  'fg=gray'

          # (optional extra if you ever used the old syntax_keyword)
          # ble-face -s command_keyword           'fg=blue,bold'

          # Your custom prompt (🏠 λ) – colored directly in PS1 so no prompt_char needed
          PS1='\[\e[1;34m\]🏠\[\e[0m\] \[\e[1;33m\]λ\[\e[0m\] '
        '';
      };
    };
}
