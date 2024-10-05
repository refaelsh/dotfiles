{
  pkgs,
  ...
}:
{
  programs.nixvim = {
    imports = [
      ./auto-cmd.nix
      ./keymaps.nix
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
