{
  plugins = {
    imports = [
      ./cmp.nix
      ./lsp.nix
      ./plugins.nix
      ./one-liners.nix
      ./treesitter.nix
    ];
    haskell-scope-highlighting.enable = true;
  };
}
