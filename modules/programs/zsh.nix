{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  # Exact copy of the rich init + Dracula theme from your old home-manager zsh.nix
  oldInitContent = ''
    zmodload zsh/zprof
    fpath+=($HOME/.zsh/plugins/zsh-completions/share/zsh/site-functions)

    # Dracula theme for zsh-syntax-highlighting (exact copy)
    typeset -gA ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
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
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=#8BE9FD'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#8BE9FD'
    ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#8BE9FD'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#FF79C6'
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#F8F8F2'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#FF79C6'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#F1FA8C'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#F1FA8C'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#F8F8F2'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#FF5555'
    ZSH_HIGHLIGHT_STYLES[path]='fg=#F8F8F2'
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#FF79C6'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=#F8F8F2'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#BD93F9'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=#F8F8F2'
    ZSH_HIGHLIGHT_STYLES[default]='fg=#F8F8F2'
    ZSH_HIGHLIGHT_STYLES[cursor]='standout'
  '';
in

{
  programs.zsh = {
    enable = true;

    shellAliases = {
      cat = "bat";
    };

    autosuggestion.enable = true;
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

  # === Lassulus wrappers part (the rich zsh you actually run) ===
  config = {
    environment.systemPackages = [
      (inputs.wrappers.wrapperModules.zsh.apply {
        inherit pkgs;

        settings = {
          # keyMap removed — we use the official bindkey -v (no more list dump)
        };

        extraRC = ''
          ${oldInitContent}
          bindkey -v
        '';
      }).wrapper
    ];

    users.defaultUserShell =
      (inputs.wrappers.wrapperModules.zsh.apply {
        inherit pkgs;

        settings = { };

        extraRC = ''
          ${oldInitContent}
          bindkey -v
        '';
      }).wrapper;
  };
}
