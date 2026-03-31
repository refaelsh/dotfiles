{ inputs, ... }:
{
  flake.nixosConfigurations.myNixos = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
      system = "x86_64-linux";
    };

    modules = [
      ../../nixos/configuration.nix

      inputs.nixvim.nixosModules.nixvim
      ../../nixvim

      inputs.home-manager.nixosModules.home-manager
      ../../home-manager

      # === your original inline bits ===
      {
        environment.systemPackages = [
          # inputs.nixvim.packages.${system}.default
          # inputs.brave.packages.${system}.default
          # inputs.zen-browser.packages."${system}".default
        ];
      }

      # === KBDD FIX ===
      {
        nixpkgs.overlays = [
          (final: prev: {
            kbdd = prev.kbdd.overrideAttrs (old: {
              src = prev.fetchFromGitHub {
                owner = "qnikst";
                repo = "kbdd";
                rev = "b87e44afd5859157245eee22b11827605bfa09b9"; # upstream fix
                hash = "sha256-cbMcB6jgssfMUjemBOiE06zJK2TbzOWt1Rvt41V33Mo=";
              };
            });
          })
        ];
      }
    ];
  };
}
