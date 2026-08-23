{ inputs, ... }:
{
  flake.nixosModules.users =
    { pkgs, ... }:
    {
      users = {
        defaultUserShell = pkgs.bash;
        users.refaelsh = {
          isNormalUser = true;
          extraGroups = [
            "networkmanager"
            "wheel"
            # Required for GameMode to apply a negative nice value (renice).
            "gamemode"
          ];
          useDefaultShell = true;
        };
      };
    };
}
