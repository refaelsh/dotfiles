{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Starship hook is now unconditional (bypasses any module-order issues)
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
        # ← Starship integration (single source of truth for bash)
        interactiveShellInit = ''
          eval "$(starship init bash)"
        '';
      };
    };
}
