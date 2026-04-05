{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # profileExtra = login-shell hook (fresh Kitty window)
  # interactiveShellInit = non-login hook (when you type "bash")
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, etc.)

        # ← Starship for login shells (fresh Kitty window = bash -l)
        profileExtra = lib.mkAfter ''
          eval "$(starship init bash)"
        '';

        # ← Starship for non-login interactive shells
        interactiveShellInit = lib.mkAfter ''
          eval "$(starship init bash)"
        '';
      };
    };
}
