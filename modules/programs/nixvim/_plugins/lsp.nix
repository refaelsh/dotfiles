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
      typos_lsp.enable = true;
      beancount.enable = true;
      # Hover docs, completions, and diagnostics for NASM/GAS/GO assembly.
      # Prefer a project-local .asm-lsp.toml (or ~/.config/asm-lsp/) to pin
      # assembler + ISA; without it, diagnostics fall back to gcc/clang.
      asm_lsp = {
        enable = true;
        # Default is only asm/vmasm; include nasm so .nasm buffers get LSP too.
        filetypes = [
          "asm"
          "vmasm"
          "nasm"
        ];
      };
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
