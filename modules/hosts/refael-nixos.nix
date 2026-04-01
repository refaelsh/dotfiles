{ lib, inputs, ... }:
{
  # ── Automatic dendritic aggregator (no manual imports ever again) ──
  flake.nixosModules.nixos = { config, lib, pkgs, ... }:
  {
    imports = lib.attrValues (removeAttrs inputs.self.nixosModules [ "nixos" ]);
  };

  # ── The actual NixOS host ──
  flake.nixosConfigurations.myNixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };

    modules = [
      # One line = all your features (brave, kitty, nixvim, future stuff) are pulled in automatically
      inputs.self.nixosModules.nixos

      inputs.home-manager.nixosModules.home-manager
      "${inputs.self}/home-manager"

      # KBDD overlay
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
