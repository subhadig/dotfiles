" Kotlin specific settings

" Functions
function! CompileAndRunKotlin()
    update
    execute "!" . "$DOTRCDIR/bin/compile-run-kotlin " . "\"%:p:t\""
endfunction

" Key bindings
nnoremap <F9> :call CompileAndRunKotlin()<cr>
