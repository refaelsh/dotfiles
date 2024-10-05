{
  plugins.lsp = {
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
}
