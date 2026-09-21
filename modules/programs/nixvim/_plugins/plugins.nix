{
  plugins = {
    auto-save = {
      enable = true;
      settings = {
        # execution_message.cleaning_interval = 5000;
      };
    };

    hardtime = {
      enable = true;
      settings = {
        showmode = false;
        disable_mouse = false;
      };
    };

    #   orgmode = {
    #      enable = true;
    #  settings = {
    #    org_startup_indented = true;
    #  };
    #};

    lualine = {
      enable = true;
      settings = {
        theme = "dracula-nvim";
      };
    };

    nvim-tree = {
      enable = true;
      settings = {
        git = {
          enable = true;
          # Legacy key. nvim-tree still maps it to filters.git_ignored.
          # false shows gitignored files instead of hiding them.
          ignore = false;
        };
        # actions.open_file.resize_window already defaults to true.
        # The camelCase key actions.openFile is not a real option and
        # nvim-tree prints "Unknown option" on every startup.
      };
    };
  };
}
