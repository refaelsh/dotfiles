{ inputs, ... }:
{
  # Correct flake-parts wrapper (this is what makes it dendritic)
  flake.nixosModules.git =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (inputs.wrappers.wrapperModules.git.apply {
          inherit pkgs;

          # Exact same config your Home-Manager used (delta + Dracula theme)
          settings = {
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
            color = {
              status = "auto";
              diff = "auto";
              branch = "auto";
              interactive = "auto";
            };
            alias = {
              lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
              st = "status -sb";
              co = "checkout";
              br = "branch";
              df = "diff";
            };
          };
        }).wrapper

        pkgs.delta # required for the pager
      ];
    };
}
