{ inputs, ... }:
{
  # Simple dendritic feature — matches your Home-Manager config 1:1
  flake.nixosModules.mangohud =
    { ... }:
    {
      programs.mangohud = {
        enable = true;
        enableSessionWide = true;
      };
    };
}
