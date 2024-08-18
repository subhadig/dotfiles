function! RunAsRestcall()
    update
    let l:request = expand("%:p")
    let l:response = substitute(l:request, ".json$", "-res.json", "")
    let l:curTabNr = tabpagenr()
    let l:nextTabNr = l:curTabNr + 1
    if tabpagenr("$") >= l:nextTabNr
        let l:nextTabBuf = tabpagebuflist(l:nextTabNr)[0]
        let l:nextTabFile = getbufinfo(l:nextTabBuf)[0].name
        echo l:nextTabFile
        if l:nextTabFile == l:response
            +tabclose
        endif
    endif
    execute "!restcall" . " " . l:request
    if v:shell_error == 0
        execute "tabe" . " " . l:response
    endif
endfunction

" Key bindings
nnoremap <F9> :call RunAsRestcall()<CR>
