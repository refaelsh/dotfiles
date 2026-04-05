{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Debug version with visible echoes so we can see exactly what runs on Kitty launch vs "bash"
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, etc.)

        # Debug + Starship for login shells (what Kitty uses on new window)
        loginShellInit = lib.mkAfter ''
          echo "=== STARSHIP LOGIN SHELL INIT RAN ==="
          eval "$(starship init bash)"
        '';

        # Debug + Starship for non-login interactive shells (when you type "bash")
        interactiveShellInit = lib.mkAfter ''
          echo "=== STARSHIP INTERACTIVE SHELL INIT RAN ==="
          eval "$(starship init bash)"
        '';
      };
    };
}
