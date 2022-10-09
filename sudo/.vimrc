call plug#begin('~/.local/share/nvim')
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'chriskempson/base16-vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf'
Plug 'plasticboy/vim-markdown'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Remove the arrow keys from all the modes (learn how to type)
noremap <UP>        <NOP>
noremap <DOWN>      <NOP>
noremap <LEFT>      <NOP>
noremap <RIGHT>     <NOP>

" Moving the viewport up and down in normal mode.
nmap <C-j> <C-e>
nmap <C-k> <C-y>

" Fold lines within a file
set foldmethod=manual

" View the number line on the left margin
set relativenumber
set number

" Enable smart search
set ignorecase
set smartcase

" Map leader
let mapleader = "\<Space>"

" Disable highlight when leader is pressed
map <silent> <leader><cr> :noh<cr>

" Highlight the current line.
noremap <silent> <leader>l :call matchadd('Search', '\%'.line('.').'l')<cr>
noremap <silent> <leader>L :call clearmatches()<cr>

" Auto read when a file is changed from the outside
set autoread

" Set wildmenu, the thin that explicitly tells you the autocomplete options available
set wildmenu

" Let's you open new files without having to save changes to current one.
set hidden

" Turn backup off, since most stuff is SVN, git, etc.
set nobackup
set noswapfile
set nowb

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Font
if has("mac") || has("macunix")
	set gfn=IBM\ Plex\ Mono:h14,Hack:h14,Source\ Code\ Pro:h15,Menlo:h15
elseif has("win16") || has("win32")
	set gfn=IBM\ Plex\ Mono:h14,Source\ Code\ Pro:h12,Bitstream\ Vera\ Sans\ Mono:h11
elseif has("gui_gtk2")
	set gfn=IBM\ Plex\ Mono:h14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("linux")
	set gfn=IBM\ Plex\ Mono:h14,:Hack\ 14,Source\ Code\ Pro\ 12,Bitstream\ Vera\ Sans\ Mono\ 11
elseif has("unix")
	set gfn=Monospace\ 11
endif

" Tex, tab and indent related
set cmdheight=2
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set wrap
set linebreak
set nolist
set tw=0
set ai
set si
set formatoptions+=cr
set conceallevel=0
set showtabline=0

" Show current git branch
let g:lightline = {
    \ 'colorscheme': 'ayu_dark',
	\ 'active': {
	\ 	'left': [ [ 'mode', 'paste' ],
	\			  [ 'gitbranch', 'readonly', 'filename', 'modified'] ]
	\	},
	\	'component_function': {
	\		'gitbranch': 'gitbranch#name',
    \       'filename': 'LightlineFilename'
	\	},
	\}

" ... let's pretend this is not here ...
function! LightlineFilename()
  return expand('%')
endfunction

" Lightline
set laststatus=2
" get rid of the `--INSERT--` status offered by vim.
set noshowmode

" Tab settings
nnoremap <silent><Leader><Left>  :execute 'tabprevious'<CR>
nnoremap <silent><Leader><Right>  :execute 'tabnext'<CR>

" Enable syntax highlighting
set termguicolors
let base16colorspace=256
syntax on

" gruvbox and theme settings
set background=dark
colorscheme base16-gruvbox-dark-hard

" make background transparent: https://stackoverflow.com/questions/37712730/set-vim-background-transparent
hi Normal guibg=NONE ctermbg=NONE

" Link python3 to vim
let g:python3_host_prog='/usr/local/bin/python3'
let g:python_highlight_all=1

" Insert current line below and above the current line.
nmap <Leader>o m`o<Esc>``
nmap <Leader>O m`O<Esc>``

" Rust specific settings
let g:rustfmt_autosave=1

" fuzzy search hotkeys
nmap <silent><C-p> :call fzf#run({ 'source': 'git ls-tree -r HEAD --name-only', 'sink': 'tabedit', 'down': '30%' })<CR>
nmap <silent><C-o>  :execute 'Buffers'<CR>

" Copy to clipboard
vnoremap  <Leader>y  "+y


" [Buffers] Jump to the existing tab/window if possible
" SEE: https://github.com/junegunn/fzf.vim/issues/98
let g:fzf_buffers_jump=1

" Markdown Configuration
"   Latex syntax highlighting on markdown files
let g:vim_markdown_math=1
"   Allow YAML front matter for Hugo `.md` files
let g:vim_markdown_frontmatter=1
"   Allow TOML front matter for Hugo `.md` files
let g:vim_markdown_toml_frontmatter=1

" autocommands
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
