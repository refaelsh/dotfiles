{ inputs, ... }:

{
  flake.nixosModules.power-management =
    { ... }:
    {
      powerManagement = {
        enable = true;
        # Changed from "performance" because the locked max frequency on this
        # laptop caused faster heat buildup during heavy multi-process workloads.
        # This led to more aggressive thermal throttling and made the whole
        # desktop feel slow.
        #
        # "schedutil" (the modern default) scales frequency up aggressively
        # under load but backs off early enough to avoid the thermal limit,
        # providing better sustained responsiveness on laptops.
        cpuFreqGovernor = "schedutil";
      };
    };
}
