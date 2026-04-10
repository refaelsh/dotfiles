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
            shellAliases = {
              # cat = "bat";
            };
          };
          extraRC = ''
            setopt no_global_rcs
            # silent vi-mode (this is the real fix — overrides the noisy wrapper behaviour)
            bindkey -v
          '';
        }).wrapper;
    in
    {
      environment.systemPackages = [ zsh-wrapped ];
      programs.zsh.enable = true;
      users.defaultUserShell = zsh-wrapped;
    };
}
