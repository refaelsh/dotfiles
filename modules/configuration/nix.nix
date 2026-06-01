{ inputs, ... }:
{
  flake.nixosModules.nix =
    { ... }:
    {
      nix = {
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";

        # Automatic garbage collection keeps the Nix store from growing
        # without bound. The current 88 GB store and 31 GB system closure
        # make nix commands slower and use more disk space over time.
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
