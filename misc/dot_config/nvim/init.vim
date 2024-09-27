call plug#begin()
Plug 'junegunn/vim-plug'
Plug 'preservim/nerdtree'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'pboettch/vim-cmake-syntax'
Plug 'Chiel92/vim-autoformat'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-fugitive'
Plug 'kevinoid/vim-jsonc'
Plug 'dyng/ctrlsf.vim'
Plug 'habamax/vim-asciidoctor'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
" Plug 'dense-analysis/ale'

Plug 'neovim/nvim-lspconfig'

Plug 'simrat39/rust-tools.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter'

Plug 'stevearc/dressing.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'lordm/vim-browser-reload-linux'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'derekwyatt/vim-fswitch'
Plug 'ryanoasis/vim-devicons'
Plug 'tomasiser/vim-code-dark'
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
Plug 'machakann/vim-highlightedyank'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'kamykn/spelunker.vim'
Plug 'kamykn/popup-menu.nvim'
Plug 'udalov/kotlin-vim'
Plug 'tpope/vim-fugitive'
Plug 'chrisbra/Colorizer'
" Plug 'kosayoda/nvim-lightbulb'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'
Plug 'aklt/plantuml-syntax'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-dispatch'
call plug#end()

" nvim-lspconfig {{{
nnoremap <leader>d :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>a :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>i :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>c :lua vim.lsp.buf.incoming_calls()<CR>
nnoremap <leader>f :lua vim.lsp.buf.formatting_seq_sync()<CR>
nnoremap <leader>h :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>r :lua vim.lsp.buf.rename()<CR>
vnoremap <leader>r :lua vim.lsp.buf.range_code_action()<CR>
" nnoremap <leader>rr :lua vim.lsp.buf.references()<CR>

" Auto-format *.* files prior to saving them.
autocmd BufWritePre *.* lua vim.lsp.buf.formatting_sync()

autocmd BufEnter,CursorHold,InsertLeave *.* lua vim.lsp.codelens.refresh()
autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()

lua << EOF
require'rust-tools'.setup({})
require('rust-tools.inlay_hints').set_inlay_hints()

require'lspconfig'.vimls.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.yamlls.setup{}
require'lspconfig'.bashls.setup{}
require'lspconfig'.dockerls.setup{}
require'lspconfig'.eslint.setup{}
require'lspconfig'.stylelint_lsp.setup{}
require'lspconfig'.cmake.setup{}
-- require'lspconfig'.ccls.setup{}
require'lspconfig'.kotlin_language_server.setup{}
require'lspconfig'.clangd.setup{}
require'lspconfig'.zk.setup{}
require'lspconfig'.pylsp.setup{}
EOF
"}}}

" nvim-cmp {{{
set completeopt=menu,menuone,noselect
lua << EOF
-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- -- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- require('lspconfig')[%YOUR_LSP_SERVER%].setup {
--   capabilities = capabilities
-- }
EOF
"}}}

" Bracey {{{
let g:bracey_refresh_on_save = "1"
"}}}

" HTML related thingies {{{
" This will complete and HTML tag.
imap ,/ </<C-X><C-O><Esc>
nnoremap ,/ </<C-X><C-O><Esc>

function! JumpToCSS()
  let id_pos = searchpos("id", "nb", line('.'))[1]
  let class_pos = searchpos("class", "nb", line('.'))[1]

  if class_pos > 0 || id_pos > 0
    if class_pos < id_pos
      execute ":vim '#".expand('<cword>')."' **/*.css"
    elseif class_pos > id_pos
      execute ":vim '.".expand('<cword>')."' **/*.css"
    endif
  endif
endfunction

nnoremap <F9> :call JumpToCSS()<CR>

" autocmd BufNewFile,BufRead *.html nnoremap <leader>d :call JumpToCSS()<CR>:cclose<CR>
"}}}

" Snippets {{{
" Rust snippets
nnoremap ,t i#[test]<CR>fn () {<CR>}<ESC>kwi
nnoremap ,tm i#[cfg(test)]<CR>mod tests {<CR>use super::*;<CR><CR>#[test]<CR>fn () {<CR>}<CR><ESC>xxxxi}<ESC>kkwwi
" HTML snippets
nnoremap ,i i<input ><Esc>i
nnoremap ,img i<img alt="Missing image." src=""><Esc>hi
nnoremap ,d i<div></div><Esc>hhhhhi
nnoremap ,f i<form></form><Esc>hhhhhhi
nnoremap ,a i<a href=""></a><Esc>hhhi
"}}}

" General Vim stuff {{{
" Integrate chezmoi with your editor
autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path %
" This will detect vimrc changes and reloads it.
augroup myvimrc
    au!
    au BufWritePost init.vim,.vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" Search down into subfolders.
" Provides tab-completion for all file-related tasks.
set path+=**
" Display all matching files when we tab complete.
set wildmenu
nmap <Enter> o<ESC>
nmap <S-Enter> O<ESC>
if &shell =~# 'fish$'
    set shell=bash
endif
au FocusLost * :wa
set foldmethod=marker
syntax on
filetype plugin indent on
syntax enable
set noswapfile
set hlsearch " Highlight all results.
set ignorecase " Ignore case in search.
set smartcase
set incsearch " Show search results as you type.
set showmatch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
nnoremap j gj
nnoremap k gk
set gdefault " Applies substitutions globally on lines.
set nocompatible
set termguicolors
set clipboard=unnamedplus
set tabstop=4
set shiftwidth=4
set expandtab
set number
set nospell
set spell spelllang=en_us
set confirm
set encoding=UTF-8
set hidden
set mouse=a
set wrap!
set spellcapcheck=
set spellsuggest+=10
set exrc
set secure
nnoremap : ;
nnoremap ; :
nnoremap <leader><Tab> :bn<CR>
" nnoremap <C-S-Tab> :bp<CR>
nnoremap <C-s> :wa<CR>
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
            \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
"}}}

" vim-fswitch{{{
nnoremap <leader>s :FSHere<CR>
"}}}

" " Autocompletion{{{
" set completeopt=longest,menuone
"
" " This will confirm a selection without creating a new line.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"
" inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
"   \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"
" inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
"   \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"
" inoremap <silent><expr> <CR>
"       \ pumvisible() ? "\<C-n>" : "\<CR>"
"
" if has("gui_running")
"     " C-Space seems to work under gVim on both Linux and win32
"     inoremap <C-Space> <C-n>
" else " no gui
"   if has("unix")
"     inoremap <Nul> <C-n>
"   else
"   " I have no idea of the name of Ctrl-Space elsewhere
"   endif
" endif
" "}}}

" vim-cpp-enhanced-highlight {{{
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_concepts_highlight = 1
"}}}

" vim-cpp-modern {{{
" let g:cpp_attributes_highlight = 1
" let g:cpp_member_highlight = 1
"}}}

" Double brackets {{{
" inoremap " ""<left>
" inoremap ' ''<left>
" inoremap ( ()<left>
" inoremap [ []<left>
" inoremap { {}<left>
" inoremap {<CR> {<CR>}<ESC>O
" inoremap {;<CR> {<CR>};<ESC>O
"}}}

" " Ale {{{
" nnoremap <leader>d :ALEGoToDefinition<CR>
" nnoremap <leader>h :ALEHover<CR>
" let g:ale_hover_to_floating_preview = 1
" let g:ale_detail_to_floating_preview = 1
" let g:ale_rust_rustfmt_options = ''
" let g:ale_open_list = 1
" let g:ale_sign_column_always = 1
" let g:ale_lint_on_enter = 1
" let g:ale_fix_on_save = 1
" let g:ale_completion_enabled = 1
" let g:ale_completion_autoimport = 1
" let g:ale_hover_cursor = 0
" let g:ale_set_balloons = 1
" let g:ale_linter_aliases = {
"             \ 'asciidoctor': 'asciidoc'
"             \}
" let g:ale_linters = {
"             \'vim': ['vimls'],
"             \'rust': ['analyzer'],
"             \'yaml': ['yamllint'],
"             \'asciidoc': ['vale', 'redpen'],
"             \'asciidoctor': ['vale', 'redpen'],
"             \'markdown': ['mdl', 'vale', 'redpen'],
"             \'text': ['vale', 'redpen'],
"             \'html': ['htmlhint', 'stylelint', 'tidy', 'vale', 'redpen'],
"             \'css': ['stylelint'],
"             \'javascript': ['eslint', 'tsserver'],
"             \'json': ['jq', 'jsonlint'],
"             \'bash': ['language_server', 'shellcheck'],
"             \'sh': ['language_server', 'shellcheck'],
"             \'cmake': ['cmakelint'],
"             \'cpp': ['clangd', 'ccls', 'gcc'],
"             \'gitcommit': ['gitlint']}
" let g:ale_fixers = {
"             \'*': ['remove_trailing_lines', 'trim_whitespace'],
"             \'rust': ['rustfmt'],
"             \'yaml': ['prettier'],
"             \'html': ['prettier'],
"             \'css': ['prettier'],
"             \'javascript': ['prettier'],
"             \'json': ['prettier'],
"             \'bash': ['shfmt'],
"             \'fish ': ['fish_indent'],
"             \'markdown': ['prettier'],
"             \'cmake': ['cmakeformat'],
"             \'cpp': ['uncrustify'],
"             \'sh': ['shfmt']}
" "}}}

" AsciiDoctor {{{
" autocmd TextChanged,TextChangedI *.adoc silent write
" autocmd TextChanged,TextChangedI *.adoc silent :!asciidoctor %
" autocmd TextChanged,TextChangedI *.adoc :!xdotool search --onlyvisible --classname Navigator windowactivate --sync key F5 && xdotool key Super+Left
" Fold sections, default `0`.
let g:asciidoctor_folding = 1
" Fold options, default `0`.
let g:asciidoctor_fold_options = 1
" Conceal *bold*, _italic_, `code` and urls in lists and paragraphs, default `0`.
" See limitations in end of the README
let g:asciidoctor_syntax_conceal = 1
" Highlight indented text, default `1`.
let g:asciidoctor_syntax_indented = 0
" List of filetypes to highlight, default `[]`
let g:asciidoctor_fenced_languages = ['python', 'c', 'rust', 'javascript']
let g:asciidoctor_img_paste_command = 'xclip -selection clipboard -t image/png -o > %s%s'
let g:asciidoctor_img_paste_pattern = 'img_%s_%s.png'
" augroup ON_ASCIIDOCTOR_SAVE | au!
"     au BufWritePost *.adoc :Asciidoctor2HTML
" augroup end
"}}}

" Markdown preview {{{
let g:mkdp_auto_close = 0
"}}}

" Quickfix {{{
" For opening the quickfix automatically after :make.
" https://vim.fandom.com/wiki/Automatically_open_the_quickfix_window_on_:make#Automatically_open_the_quickfix_window_on_:make
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Automatically fitting a quickfix window height.
" https://vim.fandom.com/wiki/Automatically_fitting_a_quickfix_window_height
au FileType qf call AdjustWindowHeight(3, 10)
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
"}}}

" Autoimport {{{
nnoremap = :Autoformat<CR>
"}}}

"Airline {{{
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" set statusline+=%{gutentags#statusline()}%m
"}}}

" NERDTree {{{
let NERDTreeShowHidden = 1
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
            \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
" " https://superuser.com/questions/1141994/autorefresh-nerdtree
" autocmd BufWritePost * NERDTreeFocus | execute 'normal R' | wincmd p
"}}}

" vim-code-dark {{{
set t_Co=256
set t_ut=
colorscheme codedark
let g:airline_theme = 'codedark'
" }}}

" Spelunker {{{
" let g:spelunker_check_type = 2
"}}}
