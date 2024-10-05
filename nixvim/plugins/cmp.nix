{
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
}
