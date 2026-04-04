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
      programs.niri = {
        enable = true;
        package = niri-wrapped; # ← this is the important line
      };
    };
}
