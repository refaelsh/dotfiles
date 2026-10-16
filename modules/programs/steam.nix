{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old NixOS steam config
  flake.nixosModules.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        # Remote Play and Source dedicated-server ports stay closed (the
        # module defaults). Those options accept inbound Steam ports from
        # any network, and this laptop joins networks it does not trust.
        # Launching games and connecting outbound does not need them.
        # Hosting Remote Play or a Source dedicated server would.
        # Steam's FHS env does not see host PATH. gamemoderun has to live
        # inside it so a per-game launch option (`gamemoderun %command%`)
        # works. Factorio ships a native Linux build; do not put it on Proton.
        extraPackages = [ pkgs.gamemode ];
        # extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };

      # Proton Experimental here is Wine 11. Its wineserver opens /dev/ntsync
      # when that device exists and prints "ntsync: up and running."
      # PROTON_NO_NTSYNC=1 skips it. This kernel builds ntsync as a module
      # and nothing loads it, so the device is missing and Wine stays on
      # fsync. Eve Online is a Proton game and spends a lot of this 4-core
      # CPU on Windows sync calls. Loading the module creates the device.
      boot.kernelModules = [ "ntsync" ];
    };
}
