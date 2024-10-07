{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = true;
    extraOptions = [
      "-a"
      "--icons"
      "--long"
      "--extended"
    ];
  };
}

# "eza -a --icons --long --extended --git --header";
