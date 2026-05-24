{ lib, ... }:
{
  flake.nixosModules.grok-build =
    {
      pkgs,
      inputs,
      lib,
      ...
    }:
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
      environment.systemPackages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        grok
      ];
    };
}
