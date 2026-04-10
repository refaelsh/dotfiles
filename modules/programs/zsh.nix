{ inputs, ... }:
{
  # Dendritic feature — exactly matches your old Home-Manager git.nix + delta
  # Uses the official Lassulus/wrappers git module
  flake.nixosModules.zsh =
    { pkgs, ... }:
    {
      let
      myZsh = [
        (inputs.wrappers.wrapperModules.zsh.apply {
          inherit pkgs;

          settings = {
            keyMap = "viins";
          };
        }).wrapper
      ];
      in{}
      # programs.zsh.enable = true;
      # users.users.yourusername.shell = myZsh;
    };

}
