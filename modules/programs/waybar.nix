{ inputs, ... }:

{
  # Dendritic feature using the official Lassulus/wrappers waybar module
  flake.nixosModules.waybar = { pkgs, ... }:
    let
      waybar-wrapped = (inputs.wrappers.wrapperModules.waybar.apply {
        inherit pkgs;

        # Your Waybar JSON config
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 30;
            # Add your modules here
          };
        };

        # ← CORRECT option name
        style.css = ''
          * {
            font-family: "Fira Code", "FiraCode Nerd Font";
            font-size: 13px;
          }
          window#waybar {
            background: #282A36;
            color: #F8F8F2;
          }
          /* Add the rest of your CSS here */
        '';
      }).wrapper;
    in
    {
      environment.systemPackages = [ waybar-wrapped ];
    };
}
