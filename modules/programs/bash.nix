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
          bind 'set enable-bracketed-paste off'
        '';
      };
    };
}
