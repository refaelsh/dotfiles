{ inputs, ... }:
{
  flake.nixosModules.environment-variables =
    { ... }:
    {
      environment.variables = {
        EDITOR = "nvim";
        # Only set TERMINAL (which app to spawn), not TERM. TERM must come from
        # the actual terminal emulator so outbound SSH and non-Ghostty sessions
        # do not advertise a terminfo remote hosts usually lack.
        TERMINAL = "ghostty";

        # Beautifully colored man pages using bat + the Dracula theme.
        # Replaces what the "colored-man-pages" zsh plugin used to provide.
        MANPAGER = "sh -c 'col -bx | bat -l man -p --theme=Dracula'";
        MANROFFOPT = "-c";
      };
    };
}
