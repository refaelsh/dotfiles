{ inputs, ... }:
{
  # Clean dendritic feature using official Lassulus/wrappers waybar module
  flake.nixosModules.waybar =
    { pkgs, ... }:
    let
      waybar-wrapped =
        (inputs.wrappers.wrapperModules.waybar.apply {
          inherit pkgs;

          settings = {
            mainBar = {
              layer = "top";
              position = "top";
              height = 32;
              margin = "4 4 0 4";
            };
          };
        }).wrapper;
    in
    {
      environment.systemPackages = [ waybar-wrapped ];
    };
}
