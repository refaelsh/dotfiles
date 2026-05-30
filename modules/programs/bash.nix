{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # interactiveShellInit works because Ghostty (and most modern terminals) launch interactive shells.
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;

        blesh.enable = true;

        interactiveShellInit = ''
          bind 'set enable-bracketed-paste off'
          shopt -s histappend cmdhist cdspell direxpand autocd
        '';
      };
    };
}
