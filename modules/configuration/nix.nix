{ inputs, ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      nix = {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";

        # Automatic garbage collection keeps the Nix store from growing
        # without bound on the 256 GB NVMe. Weekly GC plus a free-space
        # floor prevent rebuilds from filling the disk, which makes this
        # class of drive slower and increases write amplification.
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 14d";
        };

        # Run store optimisation on a timer instead of during every build.
        # The previous auto-optimise-store = true caused noticeable delays
        # on nixos-rebuild and other operations.
        optimise.automatic = true;

        settings = {
          # Disabled because we use the scheduled optimise timer above.
          # Synchronous optimisation during builds slows down the machine.
          auto-optimise-store = false;

          # If free space drops below 2 GiB during a Nix operation, delete
          # unused store paths until 10 GiB is free. Avoids running the
          # NVMe nearly full.
          min-free = 2147483648; # 2 GiB
          max-free = 10737418240; # 10 GiB

          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "refaelsh"
          ];
          # substituters = [ "https://wezterm.cachix.org" ];
          # trusted-public-keys = [ "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0=" ];
        };
      };
    };
}
