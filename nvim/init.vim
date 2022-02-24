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

" Timeoutlen for key sequence - default 1000
set timeoutlen=2000

" Set foldmethod to syntax but disable fold by default
set foldmethod=syntax
set nofoldenable

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

" Yaml speicific configuration
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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
    let g:pdfreader = "xdg-open 2>/dev/null "
    let g:wordprocessor = "xdg-open 2>/dev/null "
elseif system("uname") =~ "Darwin"
    let g:browser = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome -incognito "
    let g:browser = "/Applications/Firefox.app/Contents/MacOS/firefox --private-window "
    let g:pdfreader = "open "
    let g:wordprocessor = "open "
    let g:texteditor = "open "
endif

" View markdown files as HTML in browser
function! MarkdownView()
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2h " . "\"%:p\" " . "\"%:p\"" . ".html"
    execute "silent !" . g:browser . "\"" . "%:p" . ".html\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".html\" &"
endfunction

" Present markdown files as HTML in browser
function! MarkdownPresent()
    execute "silent !" . "pandoc -s --webtex -t slidy -c $HOME/workspaces/personal/dotfiles/pandoc/darkdown.css " . "\"%:p\"" . " -o " . "\"%:p\"" . ".html"
    execute "silent !" . g:browser . "\"" . "%:p" . ".html\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".html\" &"
endfunction

" View markdown files as PDF in the preferred pdf-reader
function! MarkdownPdfView()
    cd %:p:h
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2p " . "\"%:p\" " . "\"%:p\"" . ".pdf"
    execute "silent !" . g:pdfreader . "\"" . "%:p" . ".pdf\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".pdf\" &"
    cd -
endfunction

" View markdown files as MS Word document in the system default word processor
function! MarkdownWordDocView()
    cd %:p:h
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2d " . "\"%:p\" " . "\"%:p\"" . ".docx"
    execute "silent !" . g:wordprocessor . "\"" . "%:p" . ".docx\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".docx\" &"
    cd -
endfunction

" View markdown files as plain text document in the system default text editor
function! MarkdownTextView()
    cd %:p:h
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2t " . "\"%:p\" " . "\"%:p\"" . ".txt"
    execute "silent !" . g:texteditor . "\"" . "%:p" . ".txt\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".txt\" &"
    cd -
endfunction

" Show markdown headers in the quickfix window without the filename and
" positions
function! MarkdownTOC()
    vim /^#/ %
    copen 20
    setlocal conceallevel=2 concealcursor=nc
    syntax match quickFixFileNamePosition /^[^#]*/ transparent conceal
endfunction


" Custom key bindings

" Markdown
nnoremap <localleader>mv :call MarkdownView()<cr>
nnoremap <localleader>mp :call MarkdownPresent()<cr>
nnoremap <localleader>md :call MarkdownPdfView()<cr>
nnoremap <localleader>mw :call MarkdownWordDocView()<cr>
nnoremap <localleader>mx :call MarkdownTextView()<cr>
vnoremap <localleader>mtf :!$HOME/workspaces/personal/dotfiles/nvim/scripts/markdown_table_format.py<cr>
nnoremap <localleader>mc :call MarkdownTOC()<cr>

"" Yank link in markdown
nnoremap <localleader>mly ^f(vi("+y

"" Convert to link in markdown
nnoremap <localleader>mlc ^wi[<Esc>f>gea]<Esc>lcth(<Esc>A)<Esc>

"" Convert to automatic link in markdown
nnoremap <localleader>mlca ciW<<C-r>"><Esc>

" fzf
nnoremap <silent> <C-p> :FZF -q !.png$\  --preview file\ {+1}\|grep\ -qv\ [PNG]\ &&\ cat\ {}<cr>

" Tabs

"" Open a new tab
nnoremap <localleader>t :tabe<cr>
"" Open a new tab after last tab
nnoremap <localleader>T :$tabe<cr>

" Window
"" Resize horizontal window
nnoremap <silent> <C-w>+ :resize +20<cr>
nnoremap <silent> <C-w>- :resize -20<cr>
"" Resize vertical window
nnoremap <silent> <C-w>> :vertical resize +30<cr>
nnoremap <silent> <C-w>< :vertical resize -30<cr>

" Open explore
nnoremap <localleader>f :Texplore<cr>

" Reload vimrc
nnoremap <localleader><localleader> :source $MYVIMRC<cr>

" Open search result pane
nnoremap <silent> <C-o> :copen<cr>

" Navigate to next or previous matches during search
nnoremap <silent> <C-j> :cn<cr>
nnoremap <silent> <C-k> :cp<cr>

" Remap F1 key so that the annoying help does not come up when F1 key is
" touched by mistake on Mac
nnoremap <F1> <Esc>
inoremap <F1> <Esc>

" Navigation in command mode
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" Json formatting
nnoremap <silent> <localleader>jf :!$HOME/workspaces/personal/dotfiles/bin/json-format<cr>
vnoremap <silent> <localleader>jf :!$HOME/workspaces/personal/dotfiles/bin/json-format<cr>

" Copy to system clipboard
vnoremap <silent> <localleader>y "+y

" Python specific keybindings
autocmd FileType python nnoremap <F9> :w<CR>:exec "!" shellescape(expand("%:p"), 1)<CR>

" Load Java speicific init file
autocmd FileType java source $HOME/workspaces/personal/dotfiles/nvim/java-init.vim
