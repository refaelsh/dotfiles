{
  pkgs,
  ...
}:
{
  programs.nixvim = {
    imports = [
      ./opts.nix
      ./plugins
    ];
  };

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
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
  };
}
