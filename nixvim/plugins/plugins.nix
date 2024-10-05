{
  plugins = {
    otter = {
      enable = true;
      autoActivate = false;
    };

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

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        mapping = {
          "<C-d>" = # Lua
            "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = # Lua
            "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = # Lua
            "cmp.mapping.complete()";
          "<C-e>" = # Lua
            "cmp.mapping.close()";
          "<Tab>" = # Lua
            "cmp.mapping(cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<S-Tab>" = # Lua
            "cmp.mapping(cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select}), {'i', 's'})";
          "<CR>" = # Lua
            "cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace })";
        };
        window = {
          completion.__raw = ''cmp.config.window.bordered()'';
          documentation.__raw = ''cmp.config.window.bordered()'';
        };
        snippet.expand = # lua
          "function(args) require('luasnip').lsp_expand(args.body) end";
        sources = [
          {
            name = "buffer";
            priority = 500;
          }
          {
            name = "calc";
            priority = 150;
          }
          {
            name = "conventionalcommits";
            priority = 300;
          }
          {
            name = "cmdline";
            priority = 300;
          }
          {
            name = "cmdline-history";
            priority = 300;
          }
          {
            name = "dictionary";
            priority = 300;
          }
          {
            name = "friendly-snippets";
            priority = 750;
          }
          {
            name = "fuzzy-buffer";
            priority = 750;
          }
          {
            name = "fuzzy-path";
            priority = 750;
          }
          {
            name = "git";
            priority = 250;
          }
          {
            name = "luasnip";
            priority = 750;
          }
          {
            name = "nvim_lsp";
            priority = 1000;
          }
          {
            name = "nvim_lsp_document_symbol";
            priority = 1000;
          }
          {
            name = "nvim_lsp_signature_help";
            priority = 1000;
          }
          {
            name = "orgmode";
            priority = 250;
          }
          {
            name = "path";
            priority = 300;
          }
          {
            name = "rg";
            priority = 300;
          }
          {
            name = "spell";
            priority = 300;
          }
          {
            name = "treesitter";
            priority = 850;
          }
          {
            name = "yanky";
            priority = 250;
          }
          {
            name = "zsh";
            priority = 250;
          }
        ];
      };
    };

    lsp = {
      enable = true;
      inlayHints = true;
      keymaps.lspBuf = {
        "<leader>d" = "definition";
        "<leader>a" = "code_action";
        "<leader>i" = "implementation";
        "<leader>ic" = "incoming_calls";
        "<leader>f" = "format";
        "<leader>h" = "hover";
        "<leader>r" = "rename";
      };
      servers = {
        nixd.enable = true;
        yamlls.enable = true;
        bashls.enable = true;
        cmake.enable = true;
        clangd.enable = true;
        pylsp.enable = true;
        taplo.enable = true;
        marksman.enable = true;
        jsonls.enable = true;
        hls = {
          enable = true;
          filetypes = [
            "haskell"
            "lhaskell"
            "cabal"
          ];
        };
        lua-ls.enable = true;
      };
    };
  };
}
