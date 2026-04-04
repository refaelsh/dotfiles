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

            binds."Mod+Return" = {
              spawn-sh = "kitty";
            };
          };
        }).wrapper;
    in
    {
      environment.systemPackages = [ niri-wrapped ];
    };
}
