call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'morhetz/gruvbox'
call plug#end()

set relativenumber
set number

set wildmenu

let mapleader = " "

nmap <Leader>w :w!<CR>
nmap <Leader>e :e!<CR>

map <silent> <Leader><CR> :noh<CR>

nnoremap <Leader><Left> :execute 'tabprevious'<CR>
nnoremap <Leader><Right> :execute 'tabnext'<CR>

set cmdheight=2
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=500
set ai
set si
set wrap
set formatoptions+=cr

let g:lightline = {
    \ 'active': {
    \   'left': [['mode', 'paste'],
    \            ['gitbranch', 'readonly', 'filename', 'modified']]
    \   },
    \ 'component_function': {
    \       'gitbranch': 'gitbranch#name'
    \   },
    \}
set laststatus=2
set noshowmode

set t_Co=256
syntax on
set background=dark
colorscheme gruvbox
let g:gruvbox_dark_constrast='soft'
