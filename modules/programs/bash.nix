{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Uses programs.bash.promptInit (the proper NixOS way for Starship)
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, initExtra, etc.)

        # ← Single source of truth for Starship (works for login shells + sub-shells)
        promptInit = lib.mkAfter ''
          eval "$(starship init bash)"
        '';
      };
    };
}
