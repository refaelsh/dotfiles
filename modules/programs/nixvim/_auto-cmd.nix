{
  autoCmd = [
    {
      event = [
        "bufenter"
        # "cursorhold" and "cursorholdi" removed to stop repeated `checktime`
        # calls (disk checks) every few seconds while the cursor is idle.
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
      # Format on save via LSP only when an attached server supports it.
      # The old pattern "*>8" was invalid autocmd syntax and did nothing useful.
      event = [ "BufWritePre" ];
      callback = /* lua */ ''
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          for _, client in ipairs(clients) do
            if client.supports_method("textDocument/formatting") then
              vim.lsp.buf.format({ async = false, timeout_ms = 2000 })
              return
            end
          end
        end
      '';
    }

    {
      # Assembly mnemonics and registers trip English spellcheck constantly.
      event = [ "FileType" ];
      pattern = [
        "asm"
        "nasm"
        "vmasm"
      ];
      command = "setlocal nospell";
    }

  ];
}
