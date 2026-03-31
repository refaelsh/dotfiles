{ pkgs, ... }:
{
  flake.nixosModules.brave =
    { config, lib, ... }:
    {
      # Exact same Brave config you had in Home-Manager, but now as a NixOS dendritic module
      programs.chromium = {
        enable = true;
        package = pkgs.brave;

        # ← This is the NixOS name (was commandLineArgs in Home-Manager)
        extraArgs = [
          "--disable-background-networking"
          "--disable-default-apps"
          "--disable-features=TranslateUI"
        ];
      };
    };
}
