{ lib, inputs, ... }:
{
  # This is the real dendritic magic:
  # Every file in modules/ that exports flake.nixosModules.<name>
  # is automatically included. No editing needed ever again.
  flake.nixosModules.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = lib.attrValues (removeAttrs inputs.self.nixosModules [ "nixos" ]);
    };
}
