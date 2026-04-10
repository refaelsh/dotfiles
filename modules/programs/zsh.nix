{ inputs, ... }:
{
  # Dendritic feature — exactly matches your old Home-Manager git.nix + delta
  # Uses the official Lassulus/wrappers git module
  flake.nixosModules.zsh =
    { pkgs, ... }:
    let
      zsh-wrapped =
        (inputs.wrappers.wrapperModules.zsh.apply {
          inherit pkgs;

          settings = {
            keyMap = "viins";
          };
        }).wrapper;
    in
    {
      environment.systemPackages = [ zsh-wrapped ];
      programs.zsh.enable = true;
      users.defaultUserShell = zsh-wrapped;
    };
}
