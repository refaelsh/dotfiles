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
              ls = null;
            };

            autoSuggestions.enable = true;

            completion = {
              enable = true;
              extraCompletions = true;
              caseInsensitive = true;
              colors = true;
              fuzzySearch = true;
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

            # autocd = true;
            # keyMap = "viins";
            integrations.fzf.enable = true;
          };

          env = {
            ZSH_AUTOSUGGEST_USE_ASYNC = "true"; # async suggestions
            ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = "20"; # optional
            ZSH_HIGHLIGHT_MAX_LENGTH = "200"; # if you keep syntax highlighting
          };

          extraRC = ''
            # Needed for debug purposes only.
            # zmodload zsh/zprof

            # Dracula theme for zsh-syntax-highlighting (exact copy of what you had)
            typeset -gA ZSH_HIGHLIGHT_STYLES
            ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
            ## Constants
            ## Entitites
            ## Functions/methods
            ZSH_HIGHLIGHT_STYLES[alias]='fg=#50FA7B'
            ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#50FA7B'
            ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#50FA7B'
            ZSH_HIGHLIGHT_STYLES[function]='fg=#50FA7B'
            ZSH_HIGHLIGHT_STYLES[command]='fg=#bd93f9'
            ZSH_HIGHLIGHT_STYLES[precommand]='fg=#50FA7B,italic'
            ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#FFB86C,italic'
            ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#FFB86C'
            ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#FFB86C'
            ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#BD93F9'
            ## Keywords
            ## Built ins
            ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8BE9FD'
            ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8BE9FD'
            ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8BE9FD'
            ## Punctuation
            ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF79C6'
            ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#FF79C6'
            ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#FF79C6'
            ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#FF79C6'
            ## Serializable / Configuration Languages
            ## Storage
            ## Strings
            ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#F1FA8C'
            ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#F1FA8C'
            ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F1FA8C'
            ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#FF5555'
            ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F1FA8C'
            ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#FF5555'
            ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#F1FA8C'
            ## Variables
            ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#FF5555'
            ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[assign]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#F8F8F2'
            ## No category relevant in spec
            ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555'
            ZSH_HIGHLIGHT_STYLES[path]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#FF79C6'
            ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#FF79C6'
            ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#BD93F9'
            #ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=?'
            #ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]='fg=?'
            #ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=?'
            #ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]='fg=?'
            ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#FF5555'
            ZSH_HIGHLIGHT_STYLES[redirection]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[arg0]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[default]='fg=#F8F8F2'
            ZSH_HIGHLIGHT_STYLES[cursor]='standout'
          '';
        }).wrapper;

    in
    {
      environment.systemPackages = [
        zsh-wrapped
        pkgs.oh-my-zsh
        pkgs.zsh-completions
        pkgs.zsh-fzf-tab
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

        # Oh My Zsh is now declarative (moved out of extraRC)
        ohMyZsh = {
          enable = true;
          plugins = [
            # "sudo" # press ESC twice → prefix last command with sudo
            "git" # extensive git aliases + completion + status prompt
            "git-extras" # completions for git-extras utilities (git-undo, git-delete-branch, …)
            "git-escape-magic" # automatically escapes special chars when you type git commands
            "gitfast" # much faster git completion (uses official git completion)
            "zsh-interactive-cd" # interactive selection when cd has multiple matches
            "colored-man-pages" # adds colors to man pages
            "extract" # `extract` command to unpack many archive types automatically
            "cp" # `cpv` command — cp with progress bar (via rsync)
            "cabal" # Haskell Cabal completion + aliases
          ];
        };
      };

      users.defaultUserShell = zsh-wrapped;
    };
}
