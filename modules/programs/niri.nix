{ inputs, ... }:
{
  flake.nixosModules.niri =
    { pkgs, ... }:
    let
      niri-wrapped =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;

          settings = {
            spawn-at-startup = [
              "waybar"
            ];

            # In your dendritic niri feature/module
            binds."Mod+Return".spawn = [ "${pkgs.kitty}/bin/kitty" ];
          };
        }).wrapper;
    in
    {
      environment.systemPackages = [ niri-wrapped ];
    };
}
