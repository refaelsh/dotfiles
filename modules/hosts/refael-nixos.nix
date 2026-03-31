{ lib, inputs, ... }:
{
  flake.nixosConfigurations.myNixos = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit inputs;
    };

    modules = [
      "${inputs.self}/nixos/configuration.nix"

      inputs.nixvim.nixosModules.nixvim
      "${inputs.self}/nixvim"

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
    ];
  };
}
