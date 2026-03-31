{ inputs, ... }:
{
  # This single file automatically includes ALL your dendritic features.
  # Just add a new modules/<feature>/default.nix and it appears here automatically.
  flake.nixosModules.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        # Core NixOS config (your old configuration.nix)
        "${inputs.self}/nixos/configuration.nix"

        # All dendritic features (add new ones here — but we'll make this even better soon)
        inputs.self.nixosModules.nixvim
        inputs.self.nixosModules.brave

        # ← Future features go here automatically once we improve it
      ];
    };
}
