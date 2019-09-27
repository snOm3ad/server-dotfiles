call plug#begin('~/.vim/plugged')
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'morhetz/gruvbox'
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'
call plug#end()

" view the line number on the left margin
set relativenumber
set number

set wildmenu
" map the leader to be the space character
let mapleader = " "

" quickly disable active highlights
map <silent> <Leader><CR> :noh<CR>

" location for fzf
set rtp+=~/.fzf

" enable easy and quick fuzzy search
nmap <silent><C-p> :call fzf#run({ 'source': 'git ls-tree -r HEAD --name-only', 'sink': 'tabedit', 'down': '30%' })<CR>

" make tabs a dream to work with.
nnoremap <silent><Leader><Left> :execute 'tabprevious'<CR>
nnoremap <silent><Leader><Right> :execute 'tabnext'<CR>
nnoremap <silent><Leader><S-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent><Leader><S-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" text, tab and indent related config
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

" lightline configurations.
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

" editor theme config
set t_Co=256
syntax on
colorscheme gruvbox
set background=dark
let g:gruvbox_constrast_dark='hard'
