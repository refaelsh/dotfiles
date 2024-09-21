{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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
      # The below is taken from: https://draculatheme.com/starship.
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
  };
}
