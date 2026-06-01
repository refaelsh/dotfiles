{ inputs, ... }:
{
  flake.nixosModules.environment-variables =
    { ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
        TERM = "ghostty";
        TERMINAL = "ghostty";

        # Beautifully colored man pages using bat + the Dracula theme.
        # Replaces what the "colored-man-pages" zsh plugin used to provide.
        MANPAGER = "sh -c 'col -bx | bat -l man -p --theme=Dracula'";
        MANROFFOPT = "-c";
      };
    };
}
