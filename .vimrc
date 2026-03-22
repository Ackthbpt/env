" Plugin manager (vim-plug)
call plug#begin()
Plug 'chr4/nginx.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdcommenter'
Plug 'powerline/powerline'
Plug 'ekalinin/Dockerfile.vim'
Plug 'drewipson/glowing-vim-markdown-preview'
Plug 'sainnhe/gruvbox-material'
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
set softtabstop=4
set expandtab

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs

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

" Gruvbox-Material specific options
"  These 2 variables are used in several locations.  Not remembering to change
"  them in all locations will just frustrate the crap out of you later.

" Available values: 'hard', 'medium', 'soft'
let g:my_gruvbox_bg = 'hard'

" Available values: 'material', 'mix', 'original'
let g:my_gruvbox_fg = 'mix'

" Set contrast.
let g:gruvbox_material_background = g:my_gruvbox_bg

" Set palette
let g:gruvbox_material_foreground = g:my_gruvbox_fg

" For better performance
let g:gruvbox_material_better_performance = 1

" Set other misc (obvious) Gruvbox Material options
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_transparent_background = 1

" This overrides the default gruvbox-material colors to something that really
" stands out.  The defaults are gray, and can barely be seen.
function! s:gruvbox_material_custom() abort
  let l:palette = gruvbox_material#get_palette(g:my_gruvbox_bg, g:my_gruvbox_fg, {})
  call gruvbox_material#highlight('SpecialKey', l:palette.aqua, l:palette.none, 'NONE')
  call gruvbox_material#highlight('NonText', l:palette.aqua, l:palette.none, 'NONE')
endfunction

augroup GruvboxMaterialCustom
  autocmd!
  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END

" Now set the theme
colorscheme gruvbox-material

" Set undo across sessions
if !isdirectory($HOME . "/.vim/undodir")
  call mkdir($HOME . "/.vim/undodir", "p")
endif
set undodir=~/.vim/undodir
set undofile
set undolevels=999
set undoreload=9999

" Visualize tabs and newlines on command
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" Use leader key (currently \) + h to toggle whitespace visibility on/off
map <leader>h :set list!<CR>

" Use leader key (currently \) + n to toggle line numbers on/off
map <leader>n :set nonumber!<CR>

" Airline plugin configurations
let g:airline#extensions#default#layout = [ [ 'a', 'b', 'c' ], [ 'x', 'y', 'z' ] ]
let g:airline#extensions#whitespace#enabled = 0

" Airline options
let g:airline_powerline_fonts = 1
let g:airline_theme = 'badwolf'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#tab_min_count = 2

" <C-x><C-o> in insert mode to autocomplete
set omnifunc=syntaxcomplete#Complete

" Allow yanking large amounts of lines between files
set viminfo='100,<10000,s1000,h

" This is some WezTerm-specific stuff to change the tab title/color
set title
set titlestring=%f
let &t_ts = "\e]1;"
let &t_fs = "\007"
