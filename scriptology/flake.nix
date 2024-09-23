{
  description = "A simple flake with shell scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    # This section defines the output for each system
    packages.x86_64-linux.default = 
      let 
        pkgs = import nixpkgs { system = "x86_64-linux"; };
      in
      pkgs.runCommand "shell-scripts" {} ''
          echo "sdfdsfds"
      '';

  };
}
