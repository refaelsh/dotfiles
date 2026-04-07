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

        shellOptions = [
          "histappend"
          "cmdhist"
          "cdspell"
          "direxpand"
          "autocd"
        ];

        interactiveShellInit = ''
          shopt -s histappend
          shopt -s cmdhist
          shopt -s cdspell
          shopt -s direxpand
          shopt -s autocd
          bind 'set enable-bracketed-paste off'
        '';
      };
    };
}
