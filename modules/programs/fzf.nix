{
  # Dendritic module for fzf (fuzzy finder).
  # Provides the package and Dracula-themed defaults via FZF_DEFAULT_OPTS.
  # Bash keybinding and completion integration (sourcing the shell scripts)
  # lives in the bash module so it runs at the right point in interactive init.
  flake.nixosModules.fzf =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.fzf ];

      environment.variables = {
        # Dracula palette for fzf popups and interfaces (Ctrl-R history search,
        # Ctrl-T file insertion, Alt-C directory jump, etc.).
        # Matches the system colors used by Starship, bat, eza, and Ghostty.
        FZF_DEFAULT_OPTS = "--color=bg+:#44475a,bg:#282a36,spinner:#f8f8f2,hl:#bd93f9,fg:#f8f8f2,header:#6272a4,info:#ffb86c,pointer:#ff79c6,marker:#ff79c6,fg+:#f8f8f2,prompt:#50fa7b,hl+:#50fa7b --border --height=50% --layout=reverse --info=inline --prompt='❯ '";
      };
    };
}
