{ inputs, ... }:
{
  # Dendritic feature — exactly matches your old Home-Manager git.nix + delta
  # Uses the official Lassulus/wrappers git module
  flake.nixosModules.git =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (inputs.wrappers.wrapperModules.zsh.apply {
          inherit pkgs;

          settings = {
            keyMap = "viins";
          };
        }).wrapper
      ];
    };
}
