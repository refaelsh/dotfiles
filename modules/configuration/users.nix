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
          ];
          useDefaultShell = true;
        };
      };
    };
}
