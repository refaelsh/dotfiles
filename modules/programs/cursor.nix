{ ... }:
{
  # Cursor editor. nixpkgs calls the package code-cursor; the command is `cursor`.
  flake.nixosModules.cursor =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.code-cursor ];
    };
}
