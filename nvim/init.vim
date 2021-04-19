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
"let g:Iosvkem_transp_bg = 1
"colorscheme Iosvkem
"hi LineNr guifg=#848383 guibg=#080808 guisp=NONE gui=NONE cterm=NONE

" Theme - one-dark
colorscheme one
set background=dark

" Scripts

" Source the fzf.vim file if exists
if filereadable("/usr/share/doc/fzf/examples/fzf.vim")
    source /usr/share/doc/fzf/examples/fzf.vim
elseif filereadable("/usr/local/opt/fzf/plugin/fzf.vim")
    source /usr/local/opt/fzf/plugin/fzf.vim
endif

" Set the preferred browser command based on the platform
if system("uname") =~ "Linux"
    let g:browser = "firefox-latest --private-window "
elseif system("uname") =~ "Darwin"
    let g:browser = "/Applications/Firefox.app/Contents/MacOS/firefox --private-window "
    let g:browser = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome -incognito "
endif

" View markdown files as HTML in browser
function! MarkdownView()
    execute "silent !" . "pandoc " . "\"%:p\"" . " -o " . "\"%:p\"" . ".html"
    execute "silent !" . g:browser . "\"" . "%:p" . ".html\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".html\" &"
endfunction

" Present markdown files as HTML in browser
function! MarkdownPresent()
    execute "silent !" . "pandoc -s --webtex -t slidy " . "\"%:p\"" . " -o " . "\"%:p\"" . ".html"
    execute "silent !" . g:browser . "\"" . "%:p" . ".html\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".html\" &"
endfunction

" Custom key bindings

" Markdown
nnoremap <localleader>v :call MarkdownView()<cr>
nnoremap <localleader>p :call MarkdownPresent()<cr>

" fzf
nnoremap <silent> <C-p> :FZF -q !.png$\  --preview file\ {+1}\|grep\ -qv\ [PNG]\ &&\ cat\ {}<cr>

" Open a new tab
nnoremap <localleader>t :tabe<cr>

" Open explore
nnoremap <localleader>f :Texplore<cr>

" Reload vimrc
nnoremap <localleader><localleader> :source $MYVIMRC<cr>

" Open search result pane
nnoremap <silent> <C-o> :copen<cr>

" Markdown

"" Yank link in markdown
nnoremap <localleader>yl ^f(vi("+y

"" Convert to link in markdown
nnoremap <localleader>cl ^wi[<Esc>f>gea]<Esc>lcth(<Esc>A)<Esc>

"" Convert to automatic link in markdown
nnoremap <localleader>cal ciW<<C-r>"><Esc>

" Remap F1 key so that the annoying help does not come up when F1 key is
" touched by mistake on Mac
nnoremap <F1> <Esc>
inoremap <F1> <Esc>
