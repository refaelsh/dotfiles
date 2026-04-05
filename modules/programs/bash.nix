{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Uses environment.loginShellInit (top-level, always runs for bash -l) + interactive
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, initExtra, etc.)

        # Starship for non-login interactive shells (when you type "bash")
        interactiveShellInit = lib.mkAfter ''
          eval "$(starship init bash)"
        '';
      };

      # ← THIS IS THE MISSING PIECE for login shells (fresh Kitty window)
      # environment.loginShellInit is sourced by every bash -l before PS1 is built
      environment.loginShellInit = lib.mkAfter ''
        eval "$(starship init bash)"
      '';
    };
}
