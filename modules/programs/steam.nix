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
        # extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };
    };
}
