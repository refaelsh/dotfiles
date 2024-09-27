# defaultEditor = true;
# vimAlias = true;
# viAlias = true;
{ self, inputs, pkgs, ... }:
{
  imports = [ inputs.nixvim.nixosModules.nixvim ];
  programs.nixvim = {
    # enable = true;
    enableMan = true;
    colorschemes.dracula-nvim.enable = true;
    performance.byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      nvimRuntime = true;
      plugins = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    opts = {
      guifont = "FiraCode Nerd Font:h8.1";
      autoread = true;
      cursorline = true;
      mouse = "a";
      undofile = true;
      undodir = "/home/refaelsh/.config/nvim";
      swapfile = false;
      foldmethod = "marker";
      hlsearch = true;
      ignorecase = true;
      completeopt = "menuone,noselect";
      smartcase = true;
      incsearch = true;
      showmatch = true;
      gdefault = true;
      termguicolors = true;
      clipboard = "unnamedplus";
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      number = true;
      relativenumber = true;
      hidden = true;
      spell = true;
      spelllang = "en_us";
      spellcapcheck = "=";
      spellsuggest = "10";
      spelloptions = "camel";
      splitright = true;
      confirm = true;
      wrap = false;
      path.__raw = ''vim.opt.path + "**"'';
      wildmenu = true;
      conceallevel = 2;
      concealcursor = "nc";
    };

    keymaps = [

      {
        mode = "n";
        key = ":";
        action = ";";
      }
      {
        mode = "n";
        key = ";";
        action = ":";
      }

      {
        mode = "v";
        key = "p";
        action = "P";
      }

      {
        mode = "n";
        key = "<leader><space>";
        action = ":noh<cr>";
      }

      {
        mode = "n";
        key = "<leader>c";
        action = "gcc";
        options.remap = true;
      }
      {
        mode = "v";
        key = "<leader>c";
        action = "gc";
        options.remap = true;
      }

      {
        mode = "n";
        key = "j";
        action = "gj";
      }
      {
        mode = "n";
        key = "k";
        action = "gk";
      }

      {
        mode = "n";
        key = "<Enter>";
        action = "o<ESC>";
      }
      {
        mode = "n";
        key = "<S-Enter>";
        action = "O<ESC>";
      }

      {
        mode = "n";
        key = ",t";
        action = "i#[test]<CR>fn () {<CR>}<ESC>kwi";
      }
      {
        mode = "n";
        key = ",tm";
        action = "i#[cfg(test)]<CR>mod tests {<CR>use super::*;<CR><CR>#[test]<CR>fn () {<CR>}<CR><ESC>xxxxi}<ESC>kkwwi";
      }

      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
      }

    ];

    autoCmd = [

      {
        event = [
          "bufenter"
          "cursorhold"
          "cursorholdi"
          "focusgained"
        ];
        pattern = [ "*.*" ];
        command = "if mode() != 'c' | checktime | endif";
      }
      {
        event = [ "FileChangedShellPost" ];
        pattern = [ "*.*" ];
        command = "echohl WarningMsg | echo \"File changed on disk. Buffer reloaded.\" | echohl None";
      }

      {
        event = [ "QuickFixCmdPost" ];
        pattern = [ "[^l]*" ];
        command = "cwindow";
      }
      {
        event = [ "QuickFixCmdPost" ];
        pattern = [ "l*" ];
        command = "lwindow";
      }

      {
        event = [ "TextYankPost" ];
        pattern = [ "*" ];
        command = "silent! lua vim.highlight.on_yank{timeout=300}";
      }

      {
        event = [ "BufWritePre" ];
        pattern = [ "*>8" ];
        command = ":lua vim.lsp.buf.format()";
      }

    ];

    extraPlugins = with pkgs.vimPlugins; [
      nvim-colorizer-lua
      nui-nvim
      (pkgs.vimUtils.buildVimPlugin {
        name = "org-bullets.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "nvim-orgmode";
          repo = "org-bullets.nvim";
          rev = "main";
          sha1 = "M9oUlEa5z7CyQWYFNlW7Am5y+P0=";
        };
      })
    ];

    extraConfigLua = # lua
      ''
        require('org-bullets').setup()
        require('colorizer').setup({
          -- mode = 'background'
        })
      '';

    plugins = {

      plantuml-syntax.enable = true;
      undotree.enable = true;
      vim-surround.enable = true;
      dressing.enable = true;
      nix.enable = true;
      # No longer maintained.
      # There is a Neovim feature request: https://github.com/neovim/neovim/issues/16339.
      lastplace.enable = true;
      cursorline.enable = true;
      indent-blankline.enable = true;
      gitsigns.enable = true;
      todo-comments.enable = true;
      fidget.enable = true;
      telescope.enable = true;
      lspkind.enable = true;
      web-devicons.enable = true;
      repeat.enable = true;
      autosource.enable = true;
      numbertoggle.enable = true;
      barbecue.enable = true;
      haskell-scope-highlighting.enable = true;
      illuminate.enable = true;
      nvim-lightbulb.enable = true;
      which-key.enable = true;
      wilder.enable = true;
      otter.enable = true;

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
  };
}
