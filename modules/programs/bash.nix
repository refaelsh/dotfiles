{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Handles programs.bash + Starship hook (single source of truth)
  flake.nixosModules.bash =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, initExtra, etc.)

        # ← Starship integration for every interactive bash (including in Kitty)
        interactiveShellInit = lib.mkIf config.programs.starship.enable ''
          eval "$(starship init bash)"
        '';
      };

    };
}
