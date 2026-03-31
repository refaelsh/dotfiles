{ inputs, ... }:
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.brave =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Brave with your exact flags — works perfectly on pure NixOS
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
