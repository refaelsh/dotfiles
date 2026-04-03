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

          # This is the ONLY correct way to set the style
          style = ''
            * {
              font-family: "Fira Code", "FiraCode Nerd Font";
              font-size: 13px;
            }
            window#waybar {
              background: #282A36;
              color: #F8F8F2;
            }
          '';
        }).wrapper;
    in
    {
      environment.systemPackages = [ waybar-wrapped ];
    };
}
