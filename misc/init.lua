  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

local function map(mode, lhs, rhs)
         local options = { noremap = true, silent = false }
         vim.keymap.set(mode, lhs, rhs, options)
     end

vim.o.guifont = "FiraCode Nerd Font:h8.1"
     vim.o.autoread = true
     vim.o.cursorline = true
     vim.o.mouse = "a"
     vim.o.undofile = true
     vim.o.undodir = "/home/refaelsh/.config/nvim"
     vim.cmd [[set noswapfile]]
     -- vim.opt.noswapfile = true
     vim.o.foldmethod = "marker"
     vim.o.hlsearch = true
     vim.o.ignorecase = true
     vim.o.completeopt = 'menuone,noselect'
     vim.o.smartcase = true
     vim.o.incsearch = true
     vim.o.showmatch = true
     vim.o.gdefault = true
     vim.o.termguicolors = true
     vim.o.clipboard = "unnamedplus"
     vim.o.tabstop = 4
     vim.o.shiftwidth = 4
     vim.o.expandtab = true
     vim.o.number = true
     vim.o.relativenumber = true
     vim.o.hidden = true
     vim.opt.spell = true
     vim.opt.spelllang = { 'en_us' }
     vim.o.spellcapcheck = "="
     vim.o.spellsuggest = "10"
     vim.opt.spelloptions = "camel"
     vim.o.splitright = true;
     vim.o.confirm = true
     vim.o.wrap = false
     vim.o.clipboard = 'unnamedplus'
     vim.opt.path = vim.opt.path + "**"
     vim.opt.wildmenu = true
     vim.cmd('au TermOpen * setlocal nospell')
     -- vim.cmd [[
     --   if &shell =~# 'fish$'
     --     set shell=bash
     --   endif
     -- ]]

map("n", "<leader><space>", ":noh<cr>")
     map("n", "<C-s>", ":wa<CR>")

map("n", "<Up>", "<Nop>")
     map("n", "<Down>", "<Nop>")
     map("n", "<Left>", "<Nop>")
     map("n", "<Right>", "<Nop>")
     map("i", "<Up>", "<Nop>")
     map("i", "<Down>", "<Nop>")
     map("i", "<Left>", "<Nop>")
     map("i", "<Right>", "<Nop>")
     map("v", "<Up>", "<Nop>")
     map("v", "<Down>", "<Nop>")
     map("v", "<Left>", "<Nop>")
     map("v", "<Right>", "<Nop>")

  vim.keymap.set('n', '<leader>c', 'gcc', { remap = true })
  vim.keymap.set('v', '<leader>c', 'gc', { remap = true })

map("n", "j", "gj")
     map("n", "k", "gk")

map("n", ":", ";")
     map("n", ";", ":")

map("n", "<Enter>", "o<ESC>")
     map("n", "<S-Enter>", "O<ESC>")

-- This is a snip it example without plugins :-)
     --     map("n", ",t", "i#[test]<CR>fn () {<CR>}<ESC>kwi")
     --     map("n", ",tm",
     --         "i#[cfg(test)]<CR>mod tests {<CR>use super::*;<CR><CR>#[test]<CR>fn () {<CR>}<CR><ESC>xxxxi}<ESC>kkwwi")

vim.api.nvim_create_autocmd({ "bufenter", "cursorhold", "cursorholdi", "focusgained" },
     { 
         pattern = "*.*", 
         command = "if mode() != 'c' | checktime | endif", 
     })
     vim.api.nvim_create_autocmd("FileChangedShellPost",
     {
         pattern = "*.*",
         command =
             "echohl WarningMsg | echo \"File changed on disk. Buffer reloaded.\" | echohl None",
     })

map("n", "<C-d>", "<C-d>zz")
     map("n", "<C-u>", "<C-u>zz")
     map("n", "n", "nzzzv")
     map("n", "N", "Nzzzv")

vim.api.nvim_create_autocmd("QuickFixCmdPost", { pattern = "[^l]*", command = "cwindow", })
      vim.api.nvim_create_autocmd("QuickFixCmdPost", { pattern = "l*", command = "lwindow", })

vim.api.nvim_create_autocmd("FocusLost", { pattern = "*.*", command = ":wa" })

vim.api.nvim_create_autocmd({ "FocusLost", "BufWritePost" },
{
    pattern = "*/home/refaelsh/repos/dotfiles/*",
    callback = function()
        vim.cmd("silent !sudo cp ~/repos/dotfiles/configuration.nix /etc/nixos/configuration.nix")
        -- vim.cmd("!git add . && git commit -m \"WIP\" && git push")
    end
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
     if not vim.loop.fs_stat(lazypath) then
         vim.fn.system {
             'git',
             'clone',
             '--filter=blob:none',
             'https://github.com/folke/lazy.nvim.git',
             '--branch=stable', -- latest stable release
             lazypath,
         }
     end
     vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

{
          "Mofiqul/dracula.nvim",
          lazy = false,    -- make sure we load this during startup if it is your main colorscheme
          priority = 1000, -- make sure to load this before all the other start plugins
          config = function()
              -- load the colorscheme here
              vim.cmd([[colorscheme dracula]])
          end
      },

'machakann/vim-highlightedyank',
      'aklt/plantuml-syntax',
      'mbbill/undotree',
      'tpope/vim-repeat',
      'tpope/vim-surround',
      'habamax/vim-asciidoctor',
      -- There is a bug. I've opened an issue.
      -- use 'tigion/nvim-asciidoc-preview'
      -- There is a bug. I've opened an issue.
      -- use { 'shuntaka9576/preview-asciidoc.nvim', run = 'yarn install' }
      "nvim-lua/plenary.nvim",
      -- 'dag/vim-fish',
      'dstein64/vim-startuptime',
      'stevearc/dressing.nvim',
      'lnl7/vim-nix',
      'kamykn/spelunker.vim',
      'jeffkreeftmeijer/vim-numbertoggle',
      'nvim-tree/nvim-web-devicons',
      'rust-lang/rust.vim',
      'jenterkin/vim-autosource',

{
          'RRethy/vim-hexokinase',
          build = 'make hexokinase',
      },

{
          'ethanholz/nvim-lastplace',
          opts = {
              lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
              lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
              lastplace_open_folds = true
          }
      },

--{
       --   'numToStr/Comment.nvim',
      --    opts = {},
       --   config = function()
        --      local opt = { expr = true, remap = true, replace_keycodes = false }
         --     vim.keymap.set('n', '<leader>c', "v:count == 0 ? '<Plug>(comment_toggle_linewise_current)' : '<Plug>(comment_toggle_linewise_count)'", opt)
          --    vim.keymap.set('x', '<leader>c', '<Plug>(comment_toggle_linewise_visual)')
          --end
      --},

{
          'yamatsum/nvim-cursorline',
          opts = {
              cursorline = {
                  enable = true,
                  timeout = 1000,
                  number = false,
              },
              cursorword = {
                  enable = true,
                  min_length = 3,
                  hl = { underline = true },
              }
          }
      },

{
          "lukas-reineke/indent-blankline.nvim",
          main = "ibl",
          opts = {},
          config = function()
              vim.cmd("let g:indent_blankline_filetype_exclude = ['norg']")
          end
      },

{
          'lewis6991/gitsigns.nvim',
          opts = {}
      },

{
          'kyazdani42/nvim-tree.lua',
          opts = {
              git = {
                  ignore = false,
              },
              actions = {
                  open_file = {
                      resize_window = true
                  }
              }
          }
      },

{
          'folke/todo-comments.nvim',
          opts = {}
      },

{
          'nvim-lualine/lualine.nvim',
          opts = { { options = { theme = 'dracula' } } }
      },

{
          'nvim-treesitter/nvim-treesitter',
          build = ':TSUpdate',
          config = function()
              require("nvim-treesitter.configs").setup({
                  ensure_installed = "all",
                  ignore_install = { 'org' },
                  auto_install = true,
                  highlight = { enable = true },
                  -- indent = { enable = true },
              })
          end
      },

{ 
          "j-hui/fidget.nvim",
          opts = {} 
      },

{
          "hrsh7th/nvim-cmp",
          lazy = false,
          -- these dependencies will only be loaded when cmp loads
          -- dependencies are always lazy-loaded unless specified otherwise
          dependencies = {
              "hrsh7th/cmp-nvim-lsp",
              "hrsh7th/cmp-buffer",
              'f3fora/cmp-spell',
              'hrsh7th/cmp-path',
              'hrsh7th/cmp-cmdline',
              'hrsh7th/cmp-git',
              'L3MON4D3/LuaSnip',
              'saadparwaiz1/cmp_luasnip',
              'rafamadriz/friendly-snippets',
          },
          config = function()
              local cmp = require 'cmp'
              cmp.setup({
                  snippet = {
                      -- REQUIRED - you must specify a snippet engine
                      expand = function(args)
                          -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                          -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                          -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                      end,
                  },
                  window = {
                      -- completion = cmp.config.window.bordered(),
                      -- documentation = cmp.config.window.bordered(),
                  },
                  mapping = cmp.mapping.preset.insert({
                      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                      ['<C-f>'] = cmp.mapping.scroll_docs(4),
                      ['<C-Space>'] = cmp.mapping.complete(),
                      ['<C-e>'] = cmp.mapping.abort(),
                      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                  }),
                  sources = cmp.config.sources({
                      {
                          name = 'orgmode',
                          name = 'spell',
                          option = {
                              keep_all_entries = false,
                              enable_in_context = function()
                                  return true
                              end,
                          },
                      },
                      {
                          name = "dictionary",
                          keyword_length = 2,
                      },
                      { name = 'nvim_lsp' },
                      { name = 'spell' },
                      { name = 'neorg' },
                      -- { name = 'vsnip' }, -- For vsnip users.
                      { name = 'luasnip' }, -- For luasnip users.
                      -- { name = 'ultisnips' }, -- For ultisnips users.
                      -- { name = 'snippy' }, -- For snippy users.
                  }, {
                          { name = 'buffer' },
                      })
              })

              -- Set configuration for specific filetype.
              cmp.setup.filetype('gitcommit', {
                  sources = cmp.config.sources({
                      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                  }, {
                          { name = 'buffer' },
                      })
              })

              -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
              cmp.setup.cmdline({ '/', '?' }, {
                  mapping = cmp.mapping.preset.cmdline(),
                  sources = {
                      { name = 'buffer' }
                  }
              })

              -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
              cmp.setup.cmdline(':', {
                  mapping = cmp.mapping.preset.cmdline(),
                  sources = cmp.config.sources({
                      { name = 'path' }
                  }, {
                          { name = 'cmdline' }
                      })
              })
          end,
      },

{
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  }
},

{
  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  }
},

{
       'nvim-orgmode/orgmode',
       event = 'VeryLazy',
       branch = "master",
       ft = { 'org' },
       config = function()
         require('orgmode').setup({
           org_agenda_files = '~/orgfiles/**/*',
           org_default_notes_file = '~/orgfiles/refile.org',
           org_startup_indented = true,
           -- mappings = {
           --     agenda = {
           --       org_babel_tangle = "<leader>t"
           --     }
           --   }
         })
       end,
     },

{
       'akinsho/org-bullets.nvim',
       config = function()
         require('org-bullets').setup({
         })
       end,
     },

{
          'neovim/nvim-lspconfig',
          config = function()
              map("n", "<leader>d", ":lua vim.lsp.buf.definition()<CR>")
              map("n", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>")
              map("v", "<leader>a", ":lua vim.lsp.buf.code_action()<CR>")
              map("n", "<leader>i", ":lua vim.lsp.buf.implementation()<CR>")
              map("n", "<leader>ic", ":lua vim.lsp.buf.incoming_calls()<CR>")
              map("n", "<leader>f", ":lua vim.lsp.buf.format()<CR>")
              map("n", "<leader>h", ":lua vim.lsp.buf.hover()<CR>")
              map("n", "<leader>r", ":lua vim.lsp.buf.rename()<CR>")

              vim.api.nvim_create_autocmd("BufWritePre", { pattern = "*.*", command = ":lua vim.lsp.buf.format()" })

              local capabilities = require('cmp_nvim_lsp').default_capabilities()

              require 'lspconfig'.nixd.setup{ capabilities = capabilities }
              require 'lspconfig'.rust_analyzer.setup { capabilities = capabilities }
              require 'lspconfig'.vimls.setup { capabilities = capabilities }
              require 'lspconfig'.yamlls.setup { capabilities = capabilities }
              require 'lspconfig'.bashls.setup { capabilities = capabilities }
              require 'lspconfig'.dockerls.setup { capabilities = capabilities }
              require 'lspconfig'.eslint.setup { capabilities = capabilities }
              require 'lspconfig'.cmake.setup { capabilities = capabilities }
              require 'lspconfig'.clangd.setup { capabilities = capabilities }
              require 'lspconfig'.pylsp.setup { capabilities = capabilities }
              require 'lspconfig'.taplo.setup { capabilities = capabilities }
              require 'lspconfig'.marksman.setup { capabilities = capabilities }
              require 'lspconfig'.jsonls.setup { capabilities = capabilities }

              require 'lspconfig'.hls.setup {
                  capabilities = capabilities,
                  filetypes = { 'haskell', 'lhaskell', 'cabal' },
                  -- on_attach = my_on_attach,
                  -- cmd = { "sdfsdfd", "--lsp" },
                  -- settings = {
                  --     haskell = {
                  --         formattingProvider = "fourmolu"
                  --     }
                  -- }
              }

              require 'lspconfig'.lua_ls.setup {
                  capabilities = capabilities,
                  on_init = function(client)
                      local path = client.workspace_folders[1].name
                      if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                          client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                              Lua = {
                                  runtime = {
                                      -- Tell the language server which version of Lua you're using
                                      -- (most likely LuaJIT in the case of Neovim)
                                      version = 'LuaJIT'
                                  },
                                  diagnostics = {
                                      -- Get the language server to recognize the `vim` global
                                      -- Now, you don't get error/warning "Undefined global `vim`".
                                      globals = { 'vim' },
                                  },
                                  -- Make the server aware of Neovim runtime files
                                  workspace = {
                                      checkThirdParty = false,
                                      library = {
                                          vim.env.VIMRUNTIME
                                          -- "${3rd}/luv/library"
                                          -- "${3rd}/busted/library",
                                      }
                                      -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                                      -- library = vim.api.nvim_get_runtime_file("", true)
                                  }
                              }
                          })
                          client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                      end
                      return true
                  end
              }
          end
      },

}, {})