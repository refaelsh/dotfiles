{ inputs, ... }:
{
  flake.nixosModules.environment-variables =
    { ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
        TERM = "wezterm";
        TERMINAL = "wezterm";
        NIXOS_OZONE_WL = "1";
      };
    };
}
