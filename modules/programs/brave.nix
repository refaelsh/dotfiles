{ pkgs, ... }:
{
  flake.nixosModules.brave =
    { config, lib, ... }:
    {
      # This is exactly the same as your old Home-Manager brave config,
      # but now as a NixOS module (dendritic style)
      programs.chromium = {
        enable = true;
        package = pkgs.brave; # ← uses the standard Brave from nixpkgs

        commandLineArgs = [
          "--disable-background-networking"
          "--disable-default-apps"
          "--disable-features=TranslateUI"
        ];
      };
    };
}
