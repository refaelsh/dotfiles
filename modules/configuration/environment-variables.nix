{ inputs, ... }:
{
  flake.nixosModules.environment-variables =
    { ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
        TERM = "ghostty";
        TERMINAL = "ghostty";
        NIXOS_OZONE_WL = "1";
      };
    };
}
