{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Starship hook now works for BOTH login shells (Kitty default) AND sub-shells
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, initExtra, etc.)

        # Starship for login shells (what Kitty uses when you open a new window)
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
