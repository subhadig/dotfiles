" Markdown specific settings

set tabstop=2
set softtabstop=2
set shiftwidth=2

" Treat the header lines as comments and don't merge them with the content
" lines when formatting them together
set comments+=n:#

" Automatically inserts newline after 80 characters when typing in Insert mode
set textwidth=80

setlocal indentexpr=CustomMarkdownIndent()

" Functions
"" View markdown files as HTML in browser
function! MarkdownView()
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2h " . "\"%:p\" " . "\"%:p\"" . ".html"
    execute "silent !" . g:private_browser . "\"" . "%:p" . ".html\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".html\" &"
endfunction

"" Present markdown files as HTML in browser
function! MarkdownPresent()
    execute "silent !" . "pandoc -s --webtex -t slidy -c $HOME/workspaces/personal/dotfiles/pandoc/darkdown.css " . "\"%:p\"" . " -o " . "\"%:p\"" . ".html"
    execute "silent !" . g:private_browser . "\"" . "%:p" . ".html\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".html\" &"
endfunction

"" View markdown files as PDF in the preferred pdf-reader
function! MarkdownPdfView()
    cd %:p:h
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2p " . "\"%:p\" " . "\"%:p\"" . ".pdf"
    execute "silent !" . g:pdfreader . "\"" . "%:p" . ".pdf\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".pdf\" &"
    cd -
endfunction

"" View markdown files as MS Word document in the system default word processor
function! MarkdownWordDocView()
    cd %:p:h
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2d " . "\"%:p\" " . "\"%:p\"" . ".docx"
    execute "silent !" . g:wordprocessor . "\"" . "%:p" . ".docx\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".docx\" &"
    cd -
endfunction

"" View markdown files as plain text document in the system default text editor
function! MarkdownTextView()
    cd %:p:h
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2t " . "\"%:p\" " . "\"%:p\"" . ".txt"
    execute "silent !" . g:texteditor . "\"" . "%:p" . ".txt\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".txt\" &"
    cd -
endfunction

"" Show markdown headers in the quickfix window without the filename and
"" positions
function! MarkdownTOC()
    vim /^#/ %
    copen 20
    setlocal conceallevel=2 concealcursor=nc
    syntax match quickFixFileNamePosition /^[^#]*/ transparent conceal
endfunction

function! ModifyTextWidth()
    let l:line=getline(".")
    " If the line ends with Markdown link or If it's a header - set a big value for textwidth
    if l:line=~'^.*\[.*\](.*' || l:line=~'^#.*'
        setlocal textwidth=500
    else
        setlocal textwidth=80 " Otherwise use normal textwidth
    endif
endfunction

function! CustomMarkdownIndent()
    let l:prev_line=getline(v:lnum - 1)
    if l:prev_line=~'^\s*[-*+] .*' " If the line is the starting of a bullet list
        return s:get_staring_space_count(l:prev_line) + 2
    else
        return -1
    endif
endfunction

function! s:get_staring_space_count(line)
py3 << endPy3
import vim
count = 0
line = vim.eval('a:line')
for c in line:
    if c == ' ':
        count = count + 1
    else:
        break
endPy3
    return py3eval("count")
endfunction

function! s:get_link_from_current_line()
    let l:line=getline(".")
    let l:starting_parenthesis_index=stridx(l:line, "(", stridx(l:line, "]") + 1)
    let l:closing_parenthesis_index=stridx(l:line, ")", stridx(l:line, "]") + 1)
    return l:line[l:starting_parenthesis_index + 1:l:closing_parenthesis_index - 1]
endfunction

function! s:decode_url(url)
py3 << endPy3
import vim
from urllib.parse import unquote
url = vim.eval('a:url')
decoded_url = unquote(url).replace('#', '\#')
endPy3
    return py3eval("decoded_url")
endfunction

function! MarkdownLinkOpenAsVideo()
    let l:url=s:get_link_from_current_line()
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/play " . l:url
endfunction

function! MarkdownLinkOpenInBrowser()
    let l:url=s:decode_url(s:get_link_from_current_line())
    execute "silent !" . g:browser . "\"" . l:url . "\" &"
endfunction

function! MarkdownLinkOpenInPrivateBrowser()
    let l:url=s:decode_url(s:get_link_from_current_line())
    execute "silent !" . g:private_browser . "\"" . l:url . "\" &"
endfunction

function! MarkdownLinkOpenInLynx()
    let l:url=s:decode_url(s:get_link_from_current_line())
    execute "silent ! tmux new-window " . g:lynxbrowser . "\"" . l:url . "\""
endfunction

function! s:get_path_from_current_line()
    let l:line=getline(".")
    let l:starting_index=stridx(l:line, "`")
    let l:ending_index=stridx(l:line, "`", l:starting_index + 1)
    return l:line[l:starting_index + 1:l:ending_index - 1]
endfunction

function! MarkdownPathOpenInTmux()
    let l:path=s:get_path_from_current_line()
    execute "silent ! tmux new-window -c " . "\"" . l:path . "\""
endfunction

function! MarkdownPathOpenInVim()
    let l:path=s:get_path_from_current_line()
    if !(stridx(l:path, "/") == 0 || stridx(l:path, "~") == 0)
        let l:path=expand("%:.:h") . "/" . l:path
    endif
    execute "tabe" . " " . l:path
endfunction

" Key bindings
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

"" Open Links
nnoremap <localleader>mlov :call MarkdownLinkOpenAsVideo()<cr>
nnoremap <localleader>mlob :call MarkdownLinkOpenInBrowser()<cr>
nnoremap <localleader>mlop :call MarkdownLinkOpenInPrivateBrowser()<cr>
nnoremap <localleader>mlol :call MarkdownLinkOpenInLynx()<cr>

"" Open path
nnoremap <localleader>mpot :call MarkdownPathOpenInTmux()<cr>
"" Open file in vim
nnoremap <localleader>mpov :call MarkdownPathOpenInVim()<cr>


" Autocmd Events
autocmd CursorMovedI *.md call ModifyTextWidth()
