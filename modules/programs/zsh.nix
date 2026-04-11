{ inputs, ... }:
{
  flake.nixosModules.zsh =
    { pkgs, ... }:

    let
      zsh-wrapped =
        (inputs.wrappers.wrapperModules.zsh.apply {
          inherit pkgs;

          settings = {
            shellAliases = {
              cat = "bat";
            };

            autoSuggestions.enable = true;

            completion = {
              enable = true;
              extraCompletions = true;
              caseInsensitive = true;
              colors = true;
              fuzzy = true;
            };

            history = {
              expireDupsFirst = true;
              expanded = true;
              save = 500;
              size = 500;
              ignoreDups = true;
              ignoreSpace = true;
              share = true;
            };

            autocd = true;
            keyMap = "viins";
            integrations.fzf.enable = true; # wrapper-native
          };

          extraRC = ''
            zmodload zsh/zprof
            fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
            source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh

            # Oh-My-Zsh (still the easiest way to keep your exact plugin list)
            export ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
            plugins=(
              sudo git git-extras git-escape-magic gitfast zsh-interactive-cd
              vi-mode colored-man-pages extract cp cabal
              # fzf is now handled by the wrapper's integration — you can drop it here if you want
            )

            source $ZSH/oh-my-zsh.sh

            # Dracula theme for zsh-syntax-highlighting (exact copy of what you had)
            typeset -gA ZSH_HIGHLIGHT_STYLES
            ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
          '';
        }).wrapper;

    in
    {
      environment.systemPackages = [
        zsh-wrapped
        pkgs.oh-my-zsh
        pkgs.zsh-you-should-use
        pkgs.zsh-completions
      ];

      programs.zsh = {
        enable = true;
        vteIntegration = true;

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
      };

      users.defaultUserShell = zsh-wrapped;
    };
}
