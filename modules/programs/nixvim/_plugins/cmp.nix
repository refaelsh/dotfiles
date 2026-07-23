{
  plugins.cmp = {
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
        completion.__raw = "cmp.config.window.bordered()";
        documentation.__raw = "cmp.config.window.bordered()";
      };
      snippet.expand = # lua
        "function(args) require('luasnip').lsp_expand(args.body) end";
      # Insert-mode sources only. cmdline/cmdline-history belong in separate
      # cmp.setup.cmdline configurations, not here. friendly-snippets is a
      # LuaSnip snippet pack (loaded via luasnip), not a cmp source. zsh was
      # leftover from the old shell setup and does nothing under bash.
      sources = [
        {
          name = "buffer";
          priority = 500;
        }
        {
          name = "conventionalcommits";
          priority = 300;
        }
        {
          name = "dictionary";
          priority = 300;
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
          name = "treesitter";
          priority = 850;
        }
        {
          name = "yanky";
          priority = 250;
        }
        {
          name = "beancount";
          priority = 250;
        }
      ];
    };
  };
}
