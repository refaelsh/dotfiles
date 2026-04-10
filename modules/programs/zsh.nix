
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
            # ── Delta (added back) ─────────────────────────────────────────────
            core = {
              pager = "delta";
            };
            interactive = {
              diffFilter = "delta --color-only";
            };
            delta = {
              syntax-theme = "Dracula";
              line-numbers = true;
              decorations = true;
              side-by-side = true;
              navigate = true;
              light = false;
            };
          };
        }).wrapper

        pkgs.delta # required for the pager
      ];
    };
}
