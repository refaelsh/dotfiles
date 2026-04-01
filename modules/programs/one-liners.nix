{ inputs, ... }:

{
  # Simple dendritic feature — just plain packages (no wrappers)
  flake.nixosModules.one-liners =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        delta
      ];
    };
}
