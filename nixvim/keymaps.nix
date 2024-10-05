{
  keymaps = [
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
