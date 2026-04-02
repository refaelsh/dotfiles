{ inputs, ... }:
{
  flake.nixosModules.networking =
    { ... }:
    {
      networking = {
        hostName = "nixos";
        networkmanager = {
          enable = true;
          wifi.powersave = false;
        };
      };
    };
}
