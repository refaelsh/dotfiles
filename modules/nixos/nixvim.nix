{ pkgs, ... }:
{
  programs.nixvim = {
    imports = [
      ./_nixvim/auto-cmd.nix
      ./_nixvim/keymaps.nix
      ./_nixvim/opts.nix
      ./_nixvim/plugins
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
        -- -- mode = 'background'
        -- })
      '';
  };
}
