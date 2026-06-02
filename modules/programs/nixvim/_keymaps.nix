{
  keymaps = [
    # Ctrl+V is bound at the Ghostty level to paste_from_clipboard for
    # consistent GUI paste behavior across the desktop. As a result it never
    # reaches Neovim.
    #
    # Ctrl+Q is the conventional fallback for the two things Ctrl+V normally
    # does inside Vim:
    # - In normal/visual mode: start or extend visual block selection.
    # - In insert mode: insert the next typed character literally (e.g. a
    #   control character or special key).
    #
    # These mappings restore the original behavior under the new key.
    {
      mode = "n";
      key = "<C-q>";
      action = "<C-v>";
      options.desc = "Visual block selection (Ctrl+V is terminal paste)";
    }
    {
      mode = "v";
      key = "<C-q>";
      action = "<C-v>";
      options.desc = "Visual block selection (Ctrl+V is terminal paste)";
    }
    {
      mode = "i";
      key = "<C-q>";
      action = "<C-v>";
      options.desc = "Insert next character literally (Ctrl+V is terminal paste)";
    }

    {
      mode = "n";
      key = ":";
      action = ";";
    }

    {
      mode = "n";
      key = ";";
      action = ":";
    }

    {
      mode = "v";
      key = "p";
      action = "P";
    }

    {
      mode = "n";
      key = "<leader><space>";
      action = ":noh<cr>";
    }

    {
      mode = "n";
      key = "<leader>c";
      action = "gcc";
      options.remap = true;
    }

    {
      mode = "v";
      key = "<leader>c";
      action = "gc";
      options.remap = true;
    }

    {
      mode = "n";
      key = "j";
      action = "gj";
    }

    {
      mode = "n";
      key = "k";
      action = "gk";
    }

    {
      mode = "n";
      key = "<Enter>";
      action = "o<ESC>";
    }

    {
      mode = "n";
      key = "<S-Enter>";
      action = "O<ESC>";
    }

    {
      mode = "n";
      key = ",t";
      action = "i#[test]<CR>fn () {<CR>}<ESC>kwi";
    }

    {
      mode = "n";
      key = ",tm";
      action = "i#[cfg(test)]<CR>mod tests {<CR>use super::*;<CR><CR>#[test]<CR>fn () {<CR>}<CR><ESC>xxxxi}<ESC>kkwwi";
    }

    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
    }

    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
    }

    {
      mode = "n";
      key = "n";
      action = "nzzzv";
    }

    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
    }
  ];
}
