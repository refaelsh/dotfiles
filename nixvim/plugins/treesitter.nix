{
  treesitter = {
    enable = true;
    nixvimInjections = true;
    settings = {
      auto_install = true;
      ensure_installed = "all";
      ignore_install = [ "org" ];
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
