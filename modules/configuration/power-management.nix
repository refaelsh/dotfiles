{ inputs, ... }:

{
  flake.nixosModules.power-management =
    { ... }:
    {
      powerManagement = {
        enable = true;
        # This laptop uses intel_pstate, which only exposes "performance" and
        # "powersave" (not schedutil). Under intel_pstate, "powersave" still
        # frequency-scales under load; it is not a fixed low-frequency lock like
        # the old acpi-cpufreq powersave governor.
        #
        # Prefer powersave over performance so multi-process desktop load does
        # not ride the thermal limit and force throttling that makes the whole
        # session feel sticky.
        cpuFreqGovernor = "powersave";
      };

      # Compressed RAM swap. On an 8 GiB machine this is the primary swap tier:
      # idle anonymous pages compress into zram instead of immediately hitting
      # the NVMe swap partition (disk swap stays mounted as last resort only).
      zramSwap = {
        enable = true;
        memoryPercent = 50;
        algorithm = "lz4";
      };

      # Kernel VM policy tuned for zram-first on low RAM:
      # - swappiness > 100 is valid and pushes anonymous reclaim toward swap
      #   devices; with zram preferred (higher priority than disk swap) that
      #   means "compress cold pages" rather than "drop file cache" or "hit disk".
      # - page-cluster=0 swaps single pages instead of 8-page clusters, which
      #   cuts zram latency under interactive desktop use.
      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.page-cluster" = 0;
      };
    };
}
