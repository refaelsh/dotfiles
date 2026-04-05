{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Starship hook now runs *after* Kitty's shell_integration (mkAfter)
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, initExtra, etc.)

        # ← Starship integration – runs LAST so it wins over Kitty
        interactiveShellInit = lib.mkAfter ''
          eval "$(starship init bash)"
        '';
      };
    };
}
