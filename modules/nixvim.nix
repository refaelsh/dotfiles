{ inputs, config, lib, pkgs, ... }:
{
  # This line now works because we added `inputs` to the module arguments
  imports = [ inputs.nixvim.nixosModules.nixvim ]; # NixOS version (you were using this)

  programs.nixvim = {
    imports = [
      ./nixvim/_config/auto-cmd.nix
      ./nixvim/_config/keymaps.nix
      ./nixvim/_config/opts.nix
      ./nixvim/_config/plugins
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
}
