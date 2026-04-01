{ inputs, ... }:

{
  # Dendritic feature — exactly matches your old Home-Manager config
  flake.nixosModules.mangohud =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        mangohud # 64-bit
        mangohud32 # 32-bit (required for Proton/Steam)
      ];

      # This is what `enableSessionWide = true` did in Home-Manager
      environment.variables.MANGOHUD = "1";
    };
}
