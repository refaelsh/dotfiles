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
      kotlin_language_server.enable = true;
      jdtls.enable = true;
      lua_ls.enable = true;
      hls = {
        enable = true;
        installGhc = false;
        filetypes = [
          "haskell"
          "lhaskell"
          "cabal"
        ];
      };
    };
  };
}
