" Line numbering
set relativenumber
set number

" Searching
set hlsearch
set ignorecase
set smartcase
set fileignorecase

" Syntaxing
filetype plugin indent on
syntax on

" Color scheme
colorscheme koehler

" Tab options
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent

" File browsing
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" Spell check
set spelllang=en
set spellfile=$HOME/workspaces/personal/dotfiles/vim-spell.en.utf-8.add

" Set tab theme
hi TabLineSel term=reverse cterm=bold ctermfg=15 ctermbg=12 gui=bold guifg=white guibg=blue
hi TabLineFill term=bold,reverse cterm=bold ctermfg=12 ctermbg=15 gui=bold guifg=blue guibg=white
hi TabLine term=bold,reverse cterm=bold ctermfg=12 ctermbg=15 gui=bold guifg=blue guibg=white
