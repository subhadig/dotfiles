" Kotlin specific settings

" Functions
function! CompileAndRunKotlin()
    update
    execute "!" . "$HOME/workspaces/personal/dotfiles/bin/compile-run-kotlin " . "\"%:p:t\""
endfunction

" Key bindings
nnoremap <F9> :call CompileAndRunKotlin()<cr>
