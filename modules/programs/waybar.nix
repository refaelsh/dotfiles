{ inputs, ... }:
{
  # Dendritic feature using the official Lassulus/wrappers waybar module
  flake.nixosModules.waybar =
    { pkgs, ... }:
    let
      waybar-wrapped =
        (inputs.wrappers.wrapperModules.waybar.apply {
          inherit pkgs;

          # ← Put your Waybar settings here (same as you had in Home-Manager or elsewhere)
          settings = {
            mainBar = {
              layer = "top";
              position = "top";
              height = 30;
              # Add your modules, etc.
            };
          };

          # ← Put your Waybar style (CSS) here
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
