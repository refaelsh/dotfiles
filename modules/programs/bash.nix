{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Uses official NixOS loginShellInit + interactiveShellInit (single source of truth)
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, initExtra, etc.)

        # Starship for login shells (fresh Kitty window)
        loginShellInit = lib.mkAfter ''
          eval "$(starship init bash)"
        '';

        # Starship for non-login interactive shells (when you type "bash")
        interactiveShellInit = lib.mkAfter ''
          eval "$(starship init bash)"
        '';
      };
    };
}
