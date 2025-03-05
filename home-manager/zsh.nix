{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    shellAliases = {
      cat = "bat";
    };
    autosuggestion.enable = true;
    defaultKeymap = "viins";
    enableCompletion = true;
    enableVteIntegration = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      save = 500;
      size = 500;
    };
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
    initExtraBeforeCompInit = # bash
      ''
        fpath+=($HOME/.zsh/plugins/zsh-completions/share/zsh/site-functions)
      '';
    plugins = [
      {
        name = "zsh-you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
    ];
    initExtra = # bash
      ''
        # Everything that follows below is Dracula theme for zsh-syntax-highlighting.
        # Taken from here: https://github.com/dracula/zsh-syntax-highlighting/blob/master/zsh-syntax-highlighting.sh.
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
    oh-my-zsh = {
      enable = true;
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
}
