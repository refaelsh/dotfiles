{
  description = "A simple flake with shell scripts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {

      # NixOS module that can be imported in your NixOS configuration
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [ ];

          config = {
            environment.systemPackages = [
              (pkgs.writeScriptBin "my-script" ''
                #!/bin/sh
                echo "Hello from my Nix packaged script!"
              '')
            ];
          };
        };

      # # If you want to make this script available outside of NixOS configuration, for example, for development or testing:
      # packages.x86_64-linux.default =
      #   let
      #     pkgs = import nixpkgs { system = "x86_64-linux"; };
      #   in
      #   pkgs.writeShellApplication {
      #     name = "git.sh";
      #     text = # bash
      #       ''
      #         echo ----------------------------Running Git---------------------------------
      #         git -C ~/repos/dotfiles add . && git -C ~/repos/dotfiles commit -m "WIP" && git -C ~/repos/dotfiles push
      #         echo ----------------------------Finished running Git---------------------------------
      #       '';
      #   };
    };
}
# (writeShellApplication {
#   name = "git.sh";
#   text = # bash
#     ''
#       echo ----------------------------Running Git---------------------------------
#       git -C ~/repos/dotfiles add . && git -C ~/repos/dotfiles commit -m "WIP" && git -C ~/repos/dotfiles push
#       echo ----------------------------Finished running Git---------------------------------
#     '';
# })
