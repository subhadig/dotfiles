" Markdown specific settings

set tabstop=2
set softtabstop=2
set shiftwidth=2

" Treat the header lines as comments and don't merge them with the content
" lines when formatting them together
set comments+=n:#

" Automatically inserts newline after 80 characters when typing in Insert mode
set textwidth=80

" Functions
"" View markdown files as HTML in browser
function! MarkdownView()
    execute "silent !" . "$HOME/workspaces/personal/dotfiles/bin/pdutil m2h " . "\"%:p\" " . "\"%:p\"" . ".html"
    execute "silent !" . g:browser . "\"" . "%:p" . ".html\" &"
    call getchar()
    execute "silent !" . "rm " . "\"%:p" . ".html\" &"
endfunction

"" Present markdown files as HTML in browser
function! MarkdownPresent()
    execute "silent !" . "pandoc -s --webtex -t slidy -c $HOME/workspaces/personal/dotfiles/pandoc/darkdown.css " . "\"%:p\"" . " -o " . "\"%:p\"" . ".html"
    execute "silent !" . g:browser . "\"" . "%:p" . ".html\" &"
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

