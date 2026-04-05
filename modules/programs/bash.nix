{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Starship now works for BOTH new Kitty windows (login shells via /etc/profile.d)
  # AND when you type "bash" (interactive shells)
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
      # /etc/profile.d scripts are sourced reliably by every bash -l
      environment.etc."profile.d/starship.sh".text = ''
        # Only run in interactive login shells
        if [ -n "$BASH_VERSION" ] && [ -n "$PS1" ]; then
          eval "$(starship init bash)"
        fi
      '';
    };
}
