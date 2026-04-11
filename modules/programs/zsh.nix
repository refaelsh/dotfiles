{ inputs, ... }:
{
  # Dendritic feature — all old home-manager/zsh.nix settings ported
  # Uses Lassulus/wrappers.zsh + only the NixOS-supported parts of programs.zsh
  # (repo re-read on every prompt — current file is modules/programs/zsh.nix on master)

  flake.nixosModules.zsh =
    { pkgs, lib, ... }:
    let
      # Tiny derivation: pulls the official Dracula zsh theme into the exact oh-my-zsh layout
      # (this replaces the entire huge manual ZSH_HIGHLIGHT_STYLES + oh-my-zsh sourcing block)
      draculaTheme = pkgs.runCommand "dracula-zsh-theme" { } ''
        mkdir -p $out/themes
        cp ${
          pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "zsh";
            rev = "master"; # you can pin a specific commit later if you want
            hash = "sha256-TuKC1wPdq2OtEeViwnAmitpdaanyXHJmBcqV+rHxy34=; # ← Nix will print the correct sha256 on first build";
          }
        }/dracula.zsh-theme $out/themes/dracula.zsh-theme
      '';

      zsh-wrapped =
        (inputs.wrappers.wrapperModules.zsh.apply {
          inherit pkgs;

          settings = {
            # keyMap = "viins";
            shellAliases = {
              cat = "bat";
            };

            # Matches old autosuggestion / completion / history
            autoSuggestions.enable = true;
            completion.enable = true;
            completion.extraCompletions = true;
            history = {
              expireDupsFirst = true;
              expanded = true;
              save = 500;
              size = 500;
            };
          };

          extraRC = ''
            # Old initContent port (zprof + fpath + you-should-use) — kept exactly as before
            zmodload zsh/zprof
            fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
            source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh

            # ← everything below this line (the huge oh-my-zsh sourcing + Dracula ZSH_HIGHLIGHT_STYLES block)
            # has been removed and replaced by the clean NixOS ohMyZsh option below
          '';
        }).wrapper;
    in
    {
      environment.systemPackages = [
        zsh-wrapped
        pkgs.oh-my-zsh
        pkgs.zsh-you-should-use
        pkgs.zsh-completions
        pkgs.zsh-fzf-tab
      ];

      programs.zsh = {
        enable = true;
        vteIntegration = true;

        # The parts the wrapper doesn't cover yet (these *are* supported in NixOS)
        syntaxHighlighting = {
          enable = true;
          highlighters = [
            "main"
            "brackets"
            "pattern"
            "regexp"
            "cursor"
            "root"
            "line"
          ];
        };

        # NEW: clean Dracula theme via pure NixOS options (no more huge extraRC section)
        # (replaces the manual oh-my-zsh sourcing + entire Dracula ZSH_HIGHLIGHT_STYLES block)
        ohMyZsh = {
          enable = true;
          theme = "dracula";
          custom = "${draculaTheme}"; # ← fixed: string path (was causing the type error)

          # plugins moved here (exactly what you had before in extraRC)
          plugins = [
            "sudo"
            "git"
            "git-extras"
            "git-escape-magic"
            "gitfast"
            "zsh-interactive-cd"
            "vi-mode"
            "colored-man-pages"
            "extract"
            "cp"
            "cabal"
            "fzf"
          ];
        };
      };

      users.defaultUserShell = zsh-wrapped;
    };
}
