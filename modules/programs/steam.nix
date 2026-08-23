{ inputs, ... }:
{
  # Simple dendritic feature — exactly matches your old NixOS steam config
  flake.nixosModules.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        # Steam's FHS env does not see host PATH. gamemoderun has to live
        # inside it so a per-game launch option (`gamemoderun %command%`)
        # works. Factorio ships a native Linux build; do not put it on Proton.
        extraPackages = [ pkgs.gamemode ];
        # extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };
    };
}
