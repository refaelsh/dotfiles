{
  autoCmd = [
    {
      event = [
        "bufenter"
        -- "cursorhold" and "cursorholdi" removed to stop repeated `checktime`
        -- calls (disk checks) every few seconds while the cursor is idle.
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
      event = [ "BufWritePre" ];
      pattern = [ "*>8" ];
      command = ":lua vim.lsp.buf.format()";
    }

  ];
}
