{ inputs, ... }:
{
  # Dendritic feature using the official Lassulus/wrappers niri module
  flake.nixosModules.niri =
    { pkgs, ... }:
    let
      niri-wrapped =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;

          # Proper Nix attrset (not a string)
          settings = {
            spawn-at-startup = [
              "waybar"
              # "dunst"
              # "swaybg -i /path/to/wallpaper.jpg"
            ];

            input.keyboard.xkb = {
              layout = "us";
            };

            prefer-no-csd = true;

            cursor = {
              hide-when-typing = true;
            };
          };
        }).wrapper;
    in
    {
      environment.systemPackages = [ niri-wrapped ];
    };
}
