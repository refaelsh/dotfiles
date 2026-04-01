{ lib, inputs, ... }:
{
  flake.nixosConfigurations.myNixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };

    modules = [
      # Core config + the single automatic aggregator
      "${inputs.self}/nixos/configuration.nix"
      inputs.self.nixosModules.nixos

      inputs.home-manager.nixosModules.home-manager
      "${inputs.self}/home-manager"

      # KBDD overlay (unchanged)
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
