{ inputs, ... }:

{
  # Dendritic feature using the official Lassulus/wrappers niri module
  # Mod + Enter opens kitty (pure Nix attrset, no raw KDL)
  flake.nixosModules.niri = { pkgs, ... }:
    let
      niri-wrapped = (inputs.wrappers.wrapperModules.niri.apply {
        inherit pkgs;

        settings = {
          spawn-at-startup = [
            "waybar"
          ];

          input.keyboard.xkb = {
            layout = "us";
          };

          prefer-no-csd = true;

          cursor = {
            hide-when-typing = true;
          };

          # Mod + Enter opens kitty
          binds = {
            "mod+enter" = {
              spawn = [ "kitty" ];
            };
          };
        };
      }).wrapper;
    in
    {
      environment.systemPackages = [ niri-wrapped ];
    };
}
