" Plugin manager (vim-plug)
call plug#begin()
Plug 'chr4/nginx.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sjl/badwolf'
Plug 'altercation/vim-colors-solarized'
Plug 'ajmwagar/vim-deus'
Plug 'preservim/nerdcommenter'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'powerline/powerline'
Plug 'tpope/vim-fugitive'
Plug 'nanotech/jellybeans.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'drewipson/glowing-vim-markdown-preview'
call plug#end()

" Don't try to be vi compatible
set nocompatible

" For plugins to load correctly
filetype plugin indent on

" Show line numbers
set number

" Show file stats
set ruler

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set autoindent
set breakindent
set formatoptions=tcqrn1
set tabstop=4
set shiftwidth=4
set shiftround
"set softtabstop=4
"set expandtab

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Formatting
map <leader>q gqip
nnoremap Q gq
xnoremap Q gq

" Color scheme and various options (terminal)
set t_Co=256
set termguicolors
set term=xterm-256color
set background=dark
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Now set the theme
colors gruvbox

" Set undo across sessions
if !isdirectory($HOME . "/.vim/undodir")
  call mkdir($HOME . "/.vim/undodir", "p")
endif
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" Visualize tabs and newlines on command
set listchars=tab:▸\ ,eol:¬
highlight SpecialKey    guifg=cyan
highlight NonText       guifg=cyan

" Use leader key (currently \) + h to toggle on/off
map <leader>h :set list!<CR> " Toggle tabs and EOL

" airline plugin configurations
let g:airline#extensions#default#layout = [ [ 'a', 'b', 'c' ], [ 'x', 'y', 'z' ] ]
let g:airline#extensions#whitespace#enabled = 1

" Airline options
let g:airline_powerline_fonts = 1
let g:airline_theme='badwolf'

set omnifunc=syntaxcomplete#Complete

" Allow yanking large amounts of lines between files
set viminfo='100,<10000,s1000,h

set title
set titlestring=%f
let &t_ts = "\e]1;"
let &t_fs = "\007"
