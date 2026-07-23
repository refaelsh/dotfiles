{
  opts = {
    guifont = "FiraCode Nerd Font:h8.1";
    autoread = true;
    cursorline = true;
    mouse = "a";
    undofile = true;
    # Keep undo history out of the nvim config directory. A dedicated state
    # path avoids polluting ~/.config/nvim with one undo file per edited path.
    undodir = "/home/refaelsh/.local/state/nvim/undo";
    swapfile = false;
    foldmethod = "marker";
    hlsearch = true;
    ignorecase = true;
    completeopt = "menuone,noselect";
    smartcase = true;
    incsearch = true;
    showmatch = true;
    gdefault = true;
    termguicolors = true;
    clipboard = "unnamedplus";
    tabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    number = true;
    relativenumber = true;
    hidden = true;
    spell = true;
    spelllang = "en_us";
    spellcapcheck = "=";
    spellsuggest = "10";
    spelloptions = "camel";
    splitright = true;
    confirm = true;
    wrap = false;
    path.__raw = ''vim.opt.path + "**"'';
    wildmenu = true;
    # conceallevel = 2;
    # concealcursor = "nc";
  };
}
