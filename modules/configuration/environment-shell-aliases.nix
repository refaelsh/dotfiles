{ inputs, ... }:
{
  flake.nixosModules.environment-shell-aliases =
    { ... }:
    {
      # Lightweight aliases that recreate Zsh/oh-my-zsh-like behavior.
      # The trailing space on sudo/watch allows aliases (from eza wrapper,
      # bash init functions, etc.) to expand after the command.
      # Complements the much larger set of git aliases in the git wrapper
      # and ls/ll from eza. Only a handful of high-value ones to avoid bloat.
      environment.shellAliases = {
        sudo = "sudo ";
        watch = "watch ";
        # Quick flip to previous dir (cd - is builtin; this is a short alias
        # some Zsh users keep for muscle memory).
        "-" = "cd -";
        # dirs and history shortcuts (common in Zsh interactive use).
        d = "dirs -v";
        h = "history";
      };
    };
}
