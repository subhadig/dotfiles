" Java specific settings

" Functions
function! InsertPythonMain()
    let l:mainfunction = ["if __name__=='__main__':"]
    call add(l:mainfunction, "    main()")
    call append(line("."), l:mainfunction)
endfunction

function! RunAsScript()
    update
    let l:file = expand("%:p")
    let l:perm = getfperm(l:file)
    if l:perm[2] == "-"
        echo "Making the file executable..."
        call setfperm(l:file, l:perm[:1] . "x" . l:perm[3:])
    endif
    echo "Executing file..."
    execute "!" . shellescape(expand("%:p"), 1)
endfunction

" Key bindings
nnoremap <F9> :call RunAsScript()<CR>
nnoremap <localleader>pm :call InsertPythonMain()<cr>
