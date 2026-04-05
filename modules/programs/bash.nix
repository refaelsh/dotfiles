{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Handles programs.bash + clean Starship hook (moved out of starship.nix)
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
        # (historySize, shellInit, etc.)

        # ← Starship integration (the line you quoted)
        # This is now the single source of truth for the bash → Starship hook
        interactiveShellInit = lib.mkIf config.programs.starship.enable ''
          eval "$(starship init bash)"
        '';
      };
    };
}
