{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = true;
    extraOptions = [
      "-a"
      "--long"
      "--extended"
      "--header"
    ];
  };
}

# "eza -a --icons --long --extended --git --header";
