{ inputs, ... }:
{
  # Dendritic feature using the official Lassulus/wrappers niri module
  # Mod + Enter opens kitty
  flake.nixosModules.niri =
    { pkgs, ... }:
    let
      niri-wrapped =
        (inputs.wrappers.wrapperModules.niri.apply {
          inherit pkgs;

          # Raw KDL string (the reliable way to avoid KDL parsing issues with this wrapper)
          settings = ''
            spawn-at-startup = [
              "waybar"
            ]

            input "keyboard" {
              xkb {
                layout = "us"
              }
            }

            prefer-no-csd = true

            cursor {
              hide-when-typing = true
            }

            binds {
              "Mod+Enter" {
                spawn "kitty"
              }
            }
          '';
        }).wrapper;
    in
    {
      environment.systemPackages = [ niri-wrapped ];
    };
}
