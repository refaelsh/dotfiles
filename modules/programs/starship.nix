{ inputs, ... }:
{
  # Dendritic feature using the official Lassulus/wrappers starship module
  # Exact same config as your old Home-Manager starship.nix
  flake.nixosModules.starship =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      starship-wrapped =
        (inputs.wrappers.wrapperModules.starship.apply {
          inherit pkgs;

          settings = {
            package = {
              disabled = true;
            };
            nodejs = {
              disabled = true;
            };
            lua = {
              disabled = true;
            };
            python = {
              disabled = true;
            };
            cmd_duration = {
              disabled = true;
            };
            git_commit = {
              tag_disabled = false;
            };
            dotnet = {
              disabled = true;
            };
            cmake = {
              disabled = true;
            };
            gcloud = {
              disabled = true;
            };
            directory = {
              home_symbol = "🏠";
              truncation_length = 8;
              truncation_symbol = "…/";
            };
            # Dracula theme (exact match to your old config)
            aws.style = "bold #ffb86c";
            cmd_duration.style = "bold #f1fa8c";
            directory.style = "bold #50fa7b";
            hostname.style = "bold #ff5555";
            git_branch.style = "bold #ff79c6";
            git_status.style = "bold #ff5555";
            username = {
              format = "[$user]($style) on ";
              style_user = "bold #bd93f9";
            };
            character = {
              success_symbol = "[λ](bold #f8f8f2)";
              error_symbol = "[λ](bold #ff5555)";
            };
            continuation_prompt = "▶▶ ";
          };
        }).wrapper;
    in
    {
      programs.starship = {
        enable = true;
        package = starship-wrapped;
      };
      # ← FORCE the wrapped binary into PATH (this is the missing piece)
      environment.systemPackages = [ starship-wrapped ];
    };
}
