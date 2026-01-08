" Line numbering
set relativenumber
set number

" Color column
set cc=80

" Searching
"set hlsearch
set ignorecase
set smartcase
set fileignorecase

" Syntaxing
filetype plugin indent on
syntax on

" Tab options
set expandtab
set autoindent
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Timeoutlen for key sequence - default 1000
set timeoutlen=2000

" Set foldmethod to syntax but disable fold by default
set foldmethod=syntax
set nofoldenable
let g:markdown_folding = 1

" File browsing (netrw)
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_banner = 0
"" Enable line number in netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
"" Opens files in new tab
let g:netrw_browse_split = 3

" Jedi-vim settings
let g:jedi#use_tabs_not_buffers = 1

" coq
let g:coq_settings = { 'auto_start': 'shut-up' }

" Spell check
set spelllang=en
set spellfile=$HOME/workspaces/personal/dotfiles/vim/vim-spell.en.utf-8.add

" This line enables the true color support.
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Note, the above line is ignored in Neovim 0.1.5 above, use this line instead.
set termguicolors

" Yaml speicific configuration
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Json speicific configuration
autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2

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
elseif filereadable("/opt/homebrew/opt/fzf/plugin/fzf.vim")
    source /opt/homebrew/opt/fzf/plugin/fzf.vim
endif

" Set the preferred browser command and other platform specific settings
if system("uname") =~ "Linux"
    "let g:browser = "firefox "
    let g:browser = "chromium "
    "let g:private_browser = "firefox --private-window "
    let g:private_browser = "chromium -incognito "
    let g:pdfreader = "xdg-open 2>/dev/null "
    let g:wordprocessor = "xdg-open 2>/dev/null "
    let g:texteditor = "open "
    " This will make it easier for nvim to find the python exec to use inside
    " venv
    let g:python3_host_prog='/usr/bin/python3'
elseif system("uname") =~ "Darwin"
    "let g:private_browser = "/Applications/Firefox.app/Contents/MacOS/firefox --private-window "
    let g:private_browser = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome -incognito "
    let g:browser = "/Applications/Firefox.app/Contents/MacOS/firefox "
    let g:browser = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome "
    let g:pdfreader = "open "
    let g:wordprocessor = "open "
    let g:texteditor = "open "
    " This will make it easier for nvim to find the python exec to use inside
    " venv
    " expand might be slower. Come up with a better way
    let g:python3_host_prog=expand($NVIM_PYTHON3_HOST_PROG)
endif
let g:lynxbrowser = "lynx -cfg=$DOTRCDIR/lynx/lynx.cfg "

" Functions
" The below function does not work
function! MarkCurrFileInNetrwB()
    let l:currFile = expand("%:p")
    let l:curTabNr = tabpagenr()
    for bufNr in tabpagebuflist(l:curTabNr)
        if getbufvar(bufNr, '&ft') == 'netrw'
            let l:winId = bufwinid(bufNr)
            call win_gotoid(l:winId)
            MF l:currFile
        endif
    endfor
endfunction

function! LoadGP()
    :packadd gp.nvim
    source $DOTRCDIR/nvim/lua/gpconfig.lua
endfunction

" Custom key bindings: Start

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
nnoremap <localleader>f :Lexplore<cr>

" Reload vimrc
nnoremap <localleader><localleader> :source $MYVIMRC <bar> doautocmd FileType<cr>

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

" Horizontal navigation with mouse wheel
nnoremap <S-ScrollWheelUp> zH
nnoremap <S-ScrollWheelDown> zL

" Json formatting
autocmd FileType json setlocal equalprg=$DOTRCDIR/bin/json-format

" Copy to system clipboard
vnoremap <silent> <localleader>y "+y

" Open Outline
nnoremap <localleader>o :Outline<cr>

" Custom key bindings: End

" Create a group for filetype-specific autocommands
augroup filetype_settings
    " Clear all previous autocommands in this group
    autocmd!

    " Load Python specific init file
    autocmd FileType python source $DOTRCDIR/nvim/python-init.vim

    " Load Java specific init file
    autocmd FileType java source $DOTRCDIR/nvim/java-init.vim

    " Load Kotlin specific init file
    autocmd FileType kotlin source $DOTRCDIR/nvim/kotlin-init.vim

    " Load Markdown specific init file
    autocmd FileType markdown source $DOTRCDIR/nvim/markdown-init.vim

    " Load Restcall specific config
    autocmd FileType json source $DOTRCDIR/nvim/restcall.vim

    " DrawIt filetype config
    autocmd BufRead,BufNewFile *.drawit setfiletype drawit
    autocmd FileType drawit set nowrap formatoptions-=tc
augroup END

source $DOTRCDIR/nvim/lua/lspconfig.lua
