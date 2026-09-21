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
    };
}
