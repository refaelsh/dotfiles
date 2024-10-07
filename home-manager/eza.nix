{
  home.file.".bla".source = ''
    sdfsdf
  '';
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = true;
    extraOptions = [
      "-a"
      "-F"
      "--long"
      "--extended"
      "--header"
    ];
  };
}

# "eza -a --icons --long --extended --git --header";
