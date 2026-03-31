{ pkgs, ... }:
{
  flake.nixosModules.brave =
    { config, lib, ... }:
    {
      # Exact same flags you had in Home-Manager, but now as a proper NixOS dendritic feature
      environment.systemPackages = [
        (pkgs.brave.override {
          commandLineArgs = [
            "--disable-background-networking"
            "--disable-default-apps"
            "--disable-features=TranslateUI"
          ];
        })
      ];
    };
}
