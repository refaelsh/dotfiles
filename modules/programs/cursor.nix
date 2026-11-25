{ ... }:
{
  # Cursor editor from the cursor flake input. The command is `cursor`.
  flake.nixosModules.cursor =
    { pkgs, inputs, ... }:
    {
      environment.systemPackages = [
        inputs.cursor.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
}
