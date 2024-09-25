{
  description = "Wezterm flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    wezterm.url = "github:wez/wezterm?dir=nix";
  };

  outputs =
    { self, nixpkgs }:
    {

      # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

      # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;
      packages.x86_64-linux.default = self.wezterm.default;

    };
}
