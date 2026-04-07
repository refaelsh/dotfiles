{ inputs, ... }:
{
  flake.nixosModules.scriptology =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        (writeShellApplication {
          name = "git.sh";
          text = ''
            echo ----------------------------Running Git---------------------------------
            git -C ~/repos/dotfiles add . && git -C ~/repos/dotfiles commit -m "WIP" && git -C ~/repos/dotfiles push
            echo ----------------------------Finished running Git---------------------------------
          '';
        })
        (writeShellApplication {
          name = "flakization.sh";
          text = ''
            sudo nixos-rebuild switch --flake ~/repos/dotfiles/#myNixos --option eval-cache false
          '';
        })
        (writeShellApplication {
          name = "update.sh";
          text = ''
            git.sh || true
            nix flake update
            flakization.sh
            cabal update
            git.sh
          '';
        })
        (writeShellApplication {
          name = "supdate.sh";
          text = ''
            git.sh || true
            flakization.sh
            git.sh
          '';
        })
        (writeShellApplication {
          name = "free.sh";
          text = ''
            sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
            sudo nix-collect-garbage --delete-old
            nix-collect-garbage --delete-old
          '';
        })
      ];
    };
}
