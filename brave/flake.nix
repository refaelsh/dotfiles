{
  description = "Brave Browser package";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      packages.x86_64-linux.brave =
        let
          pkgs = import nixpkgs {
            system = "x86_64-linux";
          };
        in
        pkgs.brave;

      # Assuming you might want to make it the default package for the flake
      # defaultPackage.x86_64-linux = self.packages.x86_64-linux.brave;
      default.x86_64-linux = nixpkgs.brave;
    };
}
