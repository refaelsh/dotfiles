{ lib, ... }:
{
  # Dendritic bash feature – pure NixOS, no Home-Manager
  # interactiveShellInit now runs on every Kitty window thanks to the -i flag above
  flake.nixosModules.bash =
    { pkgs, lib, ... }:
    {
      programs.bash = {
        enable = true;
        # Add any other bash-wide settings you want here in the future
        # (historySize, shellAliases, etc.)

        interactiveShellInit = ''
          eval "$(starship init bash)"
        '';
      };
    };
}
