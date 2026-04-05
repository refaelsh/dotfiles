{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Loud debug so we can finally see if loginShellInit (fresh Kitty window) runs at all
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, initExtra, etc.)

        # Debug + Starship for login shells (fresh Kitty window = bash -l)
        loginShellInit = lib.mkAfter ''
          echo "=== STARSHIP LOGIN SHELL INIT RAN (fresh Kitty window) ==="
          eval "$(starship init bash)"
        '';

        # Debug + Starship for non-login interactive shells (when you type "bash")
        interactiveShellInit = lib.mkAfter ''
          echo "=== STARSHIP INTERACTIVE SHELL INIT RAN (typed bash) ==="
          eval "$(starship init bash)"
        '';
      };
    };
}
