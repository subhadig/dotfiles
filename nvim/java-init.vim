" Java specific settings

" Functions
function! CompileAndRunJava()
    update
    execute "!" . "$HOME/workspaces/personal/dotfiles/bin/compile-run-java " . "\"%:p:t\""
endfunction

function! InsertJavaMain()
    let l:mainfunction = ["    public static void main(String[] args) {"]
    call add(l:mainfunction, "        ")
    call add(l:mainfunction, "    }")
    call append(line("."), l:mainfunction)
endfunction

function! InsertJavaPrintln()
    let l:mainfunction = "System.out.println();"
    call setline('.', getline('.') . l:mainfunction)
endfunction

" Key bindings
nnoremap <F9> :call CompileAndRunJava()<cr>
nnoremap <localleader>jm :call InsertJavaMain()<cr>
nnoremap <localleader>jp :call InsertJavaPrintln()<cr>
