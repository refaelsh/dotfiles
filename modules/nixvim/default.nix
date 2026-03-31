{ inputs, ... }:
{
  flake.nixosModules.nixvim = { config, lib, pkgs, ... }:
  {
    # Pull in the official nixvim base module
    imports = [ inputs.nixvim.nixosModules.nixvim ];

    programs.nixvim = {
      imports = [
        ./auto-cmd.nix
        ./keymaps.nix
        ./opts.nix
        ./plugins
      ];

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
        vim-nix
      ];

      extraConfigLua = # lua
        ''
          -- require('org-bullets').setup()
          -- require('colorizer').setup({
          --   -- mode = 'background'
          -- })
        '';
    };
  };
}
