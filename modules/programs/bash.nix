{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # environment.loginShellInit = the most reliable hook for fresh Kitty windows (bash -l)
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, etc.)

        # Debug + Starship for non-login interactive shells (when you type "bash")
        interactiveShellInit = lib.mkAfter ''
          echo "=== STARSHIP INTERACTIVE SHELL INIT RAN (typed bash) ==="
          eval "$(starship init bash)"
        '';
      };

      # ← THIS IS THE KEY HOOK for fresh Kitty windows (bash -l)
      environment.loginShellInit = lib.mkAfter ''
        echo "=== STARSHIP LOGIN SHELL INIT RAN (fresh Kitty window) ==="
        eval "$(starship init bash)"
      '';
    };
}
