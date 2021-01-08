" Line numbering
set relativenumber
set number

" Color column
set cc=80

" Searching
set hlsearch
set ignorecase
set smartcase
set fileignorecase

" Syntaxing
filetype plugin indent on
syntax on

" Tab options
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
set autoindent

" File browsing
let g:netrw_liststyle = 3
let g:netrw_winsize = 25

" Jedi-vim settings
let g:jedi#use_tabs_not_buffers = 1

" Spell check
set spelllang=en
set spellfile=$HOME/workspaces/personal/dotfiles/vim/vim-spell.en.utf-8.add

" This line enables the true color support.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Note, the above line is ignored in Neovim 0.1.5 above, use this line instead.
set termguicolors

" Theme - iosvkem
let g:Iosvkem_transp_bg = 1
colorscheme Iosvkem

" Scripts

" Source the fzf.vim file if exists
if filereadable("/usr/share/doc/fzf/examples/fzf.vim")
    source /usr/share/doc/fzf/examples/fzf.vim
endif

" Set the preferred browser command based on the platform
if system("uname") =~ "Linux"
    let g:browser = "firefox-latest --private-window "
elseif system("uname") =~ "Darwin"
    let g:browser = "/Applications/Firefox.app/Contents/MacOS/firefox --private-window "
endif

" View markdown files as HTML on browser
function! MarkdownView()
    execute "silent !" . "pandoc " . "%:p" . " -o " . "%:p" . ".html"
    execute "silent !" . g:browser . "%:p" . ".html &"
    call getchar()
    execute "silent !" . "rm " . "%:p" . ".html &"
endfunction

" Custom key bindings

" Markdownview
nnoremap <localleader>v :call MarkdownView()<cr>

" fzf
nnoremap <silent> <C-p> :FZF<cr>

" Open a new tab
nnoremap <localleader>t :tabe<cr>

" Open explore
nnoremap <localleader>f :Texplore<cr>

" Reload vimrc
nnoremap <localleader><localleader> :source $MYVIMRC<cr>
