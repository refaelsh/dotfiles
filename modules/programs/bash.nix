{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # Uses environment.interactiveShellInit (top-level hook that runs for ALL interactive shells, including Kitty's bash -l)
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, etc.)
      };

      # ← THIS IS THE HOOK THAT FINALLY WORKS for fresh Kitty windows
      environment.interactiveShellInit = lib.mkAfter ''
        eval "$(starship init bash)"
      '';
    };
}
