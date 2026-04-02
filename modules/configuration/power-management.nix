{ inputs, ... }:
{
  flake.nixosModules.power-management =
    { ... }:
    {
      powerManagement = {
        enable = true;
        cpuFreqGovernor = "performance";
      };
    };
}
