{ lib, inputs, ... }:
{
  flake.nixosConfigurations.myNixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
    };

    modules = [
      "${inputs.self}/nixos/configuration.nix"

      # ←←← NEW: our dendritic nixvim feature (includes the base nixvim module)
      inputs.self.nixosModules.nixvim

      inputs.home-manager.nixosModules.home-manager
      "${inputs.self}/home-manager"

      # Your previous inline config / packages can stay here (uncomment/adjust if needed)
      {
        environment.systemPackages = [
          # inputs.nixvim.packages.${system}.default
          # inputs.brave.packages.${system}.default
          # inputs.zen-browser.packages."${system}".default
        ];
      }

      # === KBDD FIX (unchanged) ===
      {
        nixpkgs.overlays = [
          (final: prev: {
            kbdd = prev.kbdd.overrideAttrs (old: {
              src = prev.fetchFromGitHub {
                owner = "qnikst";
                repo = "kbdd";
                rev = "b87e44afd5859157245eee22b11827605bfa09b9";
                hash = "sha256-cbMcB6jgssfMUjemBOiE06zJK2TbzOWt1Rvt41V33Mo=";
              };
            });
          })
        ];
      }
    ];
  };
}
