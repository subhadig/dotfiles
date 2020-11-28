set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Color column
set cc=80

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
nnoremap <C-p> :FZF<cr>

" Open a new tab
nnoremap <localleader>t :tabe<cr>
