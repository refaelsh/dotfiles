{
  plugins = {
    auto-save = {
      enable = true;
      settings = {
        execution_message.cleaning_interval = 5000;
      };
    };

    hardtime = {
      enable = true;
      settings = {
        showmode = false;
        disable_mouse = false;
      };
    };

    orgmode = {
      enable = true;
      settings = {
        org_startup_indented = true;
      };
    };

    lualine = {
      enable = true;
      settings = {
        theme = "dracula-nvim";
      };
    };

    nvim-tree = {
      enable = true;
      git = {
        enable = true;
        ignore = false;
      };
      actions.openFile.resizeWindow = true;
    };

    treesitter = {
      enable = true;
      nixvimInjections = true;
      nixGrammars = false;
      settings = {
        auto_install = true;
        ensure_installed = "all";
        ignore_install = [ "org" ];
        highlight.enable = true;
        indent.enable = true;
      };
    };
  };
}
