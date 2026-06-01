{ inputs, ... }:
{
  flake.nixosModules.environment-variables =
    { ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
        TERM = "ghostty";
        TERMINAL = "ghostty";
        NIXOS_OZONE_WL = "1";

        # Dracula-themed fzf (used by Ctrl-R/T/Alt-C in bash, and other tools).
        # Matches the rest of the system palette.
        FZF_DEFAULT_OPTS = "--color=bg+:#44475a,bg:#282a36,spinner:#f8f8f2,hl:#bd93f9,fg:#f8f8f2,header:#6272a4,info:#ffb86c,pointer:#ff79c6,marker:#ff79c6,fg+:#f8f8f2,prompt:#50fa7b,hl+:#50fa7b --border --height=50% --layout=reverse --info=inline --prompt='❯ '";

        # Beautifully colored man pages using bat + the Dracula theme.
        # Replaces what the "colored-man-pages" zsh plugin used to provide.
        MANPAGER = "sh -c 'col -bx | bat -l man -p --theme=Dracula'";
        MANROFFOPT = "-c";
      };
    };
}
