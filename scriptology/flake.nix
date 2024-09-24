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

              (pkgs.writeShellApplication {
                name = "git.sh";
                text = # bash
                  ''
                    echo ----------------------------Running Git---------------------------------
                    git -C ~/repos/dotfiles add . && git -C ~/repos/dotfiles commit -m "WIP" && git -C ~/repos/dotfiles push
                    echo ----------------------------Finished running Git---------------------------------
                  '';
              })
              (pkgs.writeShellApplication {
                name = "update.sh";
                text = # bash
                  ''
                    git.sh || true
                    nix flake update ~/repos/dotfiles
                    sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --option eval-cache false
                    cabal update
                    git.sh
                  '';
              })
              (pkgs.writeShellApplication {
                name = "supdate.sh";
                text = # bash
                  ''
                    git.sh || true
                    # For debug
                    # sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --show-trace --print-build-logs --verbose --option eval-cache false
                    sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --option eval-cache false
                    git.sh
                  '';
              })
              (pkgs.writeShellApplication {
                name = "free.sh";
                text = # bash
                  ''
                    sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
                    sudo nix-collect-garbage --delete-old
                    nix-collect-garbage --delete-old
                  '';
              })

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
