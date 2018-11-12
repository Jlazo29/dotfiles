"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn on syntax highlighting if it's supported
if has('syntax') && &t_Co > 2
    syntax on
endif

" Enable 256 colors palette in Gnome Terminal
"if $COLORTERM == 'gnome-terminal'
" Color chart: https://jonasjacek.github.io/colors/
set t_Co=256
set t_ut=
"endif

set nocompatible
colorscheme getafe
" getafe ubaryd gruvbox
" disable the lowermost gutter section since lightline shows the status already
set noshowmode
" Fixes lightline having a blank status
set laststatus=2

set updatetime=100

" if netrw is throwing issues
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" ----------------------------------------------------------------------------
" Bundle/plugins
" ----------------------------------------------------------------------------

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'itchyny/lightline.vim'
Plugin 'ddollar/nerdcommenter'
" requires Vim 7.3+
Plugin 'mbbill/undotree'
Plugin 'sukima/xmledit'
Plugin 'sophacles/vim-bundle-mako'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'leafgarland/typescript-vim'
Plugin 'Raimondi/delimitMate'
"Plugin 'maksimr/vim-jsbeautify'
"Plugin 'einars/js-beautify'
Plugin 'JulesWang/css.vim'
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'mxw/vim-jsx'
Plugin 'tpope/vim-fugitive'
Plugin 'crusoexia/vim-monokai'
Plugin 'tpope/vim-vividchalk'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'altercation/vim-colors-solarized'
Plugin 'bogado/file-line'
Plugin 'airblade/vim-gitgutter'
"C++ syntax highlight
Plugin 'octol/vim-cpp-enhanced-highlight'


call vundle#end()

set runtimepath^=~/.vim/bundle/ctrlp.vim

"source ~/.vim/colors.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" 
" => Basic stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"show whitespace characters
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list

" Bash like autocomplete when tabbing
set wildmode=longest,list

set number
set incsearch
set hlsearch
set showcmd
" Copy indent from current line when starting a new line
set autoindent
" Automatically indent new lines after certain characters
set smartindent
" Expand tabs into spaces
set expandtab
" Handle expanded tab spaces
set smarttab
" Use a 4 space tab
set shiftwidth=4
" number of screen lines to keep above and below the cursor when scrolling
set scrolloff=6

if has ('autocmd')
    filetype plugin indent on

" Jump to the last known cursor position when editing a file.
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" Change the indent amount for css and javascript files
    au FileType html set shiftwidth=2
    au FileType css set shiftwidth=2
    au FileType js set shiftwidth=4
endif

" Number of spaces a <Tab> is displayed as
set tabstop=4

" Toggle paste
set pastetoggle=<F6>
map <F6> :set paste!<CR>i
imap <F6> <C-O>:set paste!<CR>

" Window management
map <F10> <C-W>=
imap <F10> <C-O><C-W>=
map <F11> <C-W>-
imap <F11> <C-O><C-W>-
map <F12> <C-W>+
imap <F12> <C-O><C-W>+
map <S-F11> :res 1<CR>
imap <S-F11> <C-O>:res 1<CR>
map <S-F12> <C-W>_
imap <S-F12> <C-O><C-W>_
map <S-Up> <C-W><Up>
imap <S-Up> <C-O><C-W><Up>
map <S-Down> <C-W><Down>
imap <S-Down> <C-O><C-W><Down>
map <S-Left> <C-W><Left>
imap <S-Left> <C-O><C-W><Left>
map <S-Right> <C-W><Right>
imap <S-Right> <C-O><C-W><Right>

" Lines of command history to keep instead of the default 20
set history=100
" What to save in the viminfo file
set viminfo='100,<250,s50,h

" Turn off the highlighting matching parens plugin
let loaded_matchparen = 1

" Add '_' to word delimeters
" set iskeyword-=_

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=','
"go to start of line
imap <C-k> <C-O>^
vmap <C-k> ^
nnoremap <C-k> ^
""go to end of line
imap <C-l> <C-O>$
vmap <C-l> $
nnoremap <C-l> $
" back in history
map <M-Left> <C-O>
" forward in history
map <M-Right> <C-I>
" mark a line with character
nnoremap <leader>m '
" current window width + 5
nnoremap <F10> :vertical resize +5<CR>
" current window width - 5
nnoremap <F9> :vertical resize -5<CR>
" current window height + 5
nnoremap <F12> <C-W>+
" current window height - 5
nnoremap <F11> <C-W>-
" reset window sizes
nnoremap <S-F10> <C-W>=
"" use normal <C-W> when in insert mode
"imap <C-W> <C-O><C-W>
"" call visual line while in insert mode
"imap <C-V> <C-O><S-V>
" call UndoTree. Requires VIM 7.3+
nnoremap <leader>u :UndotreeToggle<cr>
" paste using the 0 register (always last yanked)
nnoremap <leader>p "0p
vnoremap <leader>p "0p

" remove hightlighting
nnoremap <leader><space> :nohlsearch<CR>

" Lightline config
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'gitbranch' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \}
