{ inputs, ... }:
{
  flake.nixosModules.nixvim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # Pull in the official nixvim base module
      imports = [ inputs.nixvim.nixosModules.nixvim ];

      programs.nixvim = {
        imports = [
          ./_auto-cmd.nix
          ./_keymaps.nix
          ./_opts.nix
          ./_plugins
        ];

        # Reuse the host NixOS pkgs set for plugins and tools so neovim does
        # not pull a second full nixpkgs evaluation. Prefer this over forcing
        # inputs.nixvim.inputs.nixpkgs.follows (which nixvim explicitly warns against).
        nixpkgs.useGlobalPackages = true;

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
            -- Ensure undodir exists; Neovim will not create it automatically.
            vim.fn.mkdir(vim.o.undodir, "p")

            -- require('org-bullets').setup()
            -- require('colorizer').setup({
            --   -- mode = 'background'
            -- })
          '';
      };
    };
}
