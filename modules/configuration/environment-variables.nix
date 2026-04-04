{ inputs, ... }:
{
  flake.nixosModules.environment-variables =
    { ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
        TERM = "kitty";
        TERMINAL = "kitty";
        NIXOS_OZONE_WL = "1";
      };
    };
}
