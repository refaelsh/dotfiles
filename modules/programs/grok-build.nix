{ lib, ... }:
{
  flake.nixosModules.grok-build =
    { pkgs, lib, ... }:
    {
      # programs.bash = {
      #   enable = true;
      #
      #   blesh.enable = true;
      #
      #   interactiveShellInit = ''
      #     bind 'set enable-bracketed-paste off'
      #     shopt -s histappend cmdhist cdspell direxpand autocd
      #   '';
      # };
    };
}
