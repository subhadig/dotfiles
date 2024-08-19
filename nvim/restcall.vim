function! RunAsRestcall()
    update
    let l:requestFile = expand("%:p")
    let l:responseFile = substitute(l:requestFile, ".json$", "-res.json", "")
    let l:nextTabNr = tabpagenr() + 1
    if tabpagenr("$") >= l:nextTabNr
        let l:nextTabBuf = tabpagebuflist(l:nextTabNr)[0]
        let l:nextTabFile = getbufinfo(l:nextTabBuf)[0].name
        if l:nextTabFile == l:responseFile
            +tabclose
        endif
    endif
    execute "!restcall" . " " . l:requestFile
    if v:shell_error == 0
        return l:responseFile
    else
        throw "Restcall failed"
endfunction

" Key bindings

"" Call RunAsRestcall() and open responseFile in a new tab
nnoremap <F9> :let responseFile = RunAsRestcall() <Bar> execute "silent tabe " . responseFile <Bar> unlet responseFile<CR>
