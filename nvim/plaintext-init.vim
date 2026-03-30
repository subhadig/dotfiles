" Plaintext specific settings

" Automatically inserts newline after 80 characters when typing in Insert mode
set textwidth=80

" Evaluated to get the proper indent for a line
setlocal indentexpr=CustomPlaintextIndent()

function! CustomPlaintextIndent()
    let l:prev_line=getline(v:lnum - 1)
     " If the line is the starting of a bullet or numbered list
    if l:prev_line=~'^\s*[-*+] .*' || l:prev_line=~'^\s*[0-9a-z.].*[.)] .*'
        return s:get_starting_space_count(l:prev_line)
    else
        return -1
    endif
endfunction

" Example 1: '    a) Hello world'
" Output: 7
" Example 2: '*   Hello world'
" Output: 4
function! s:get_starting_space_count(line)
    let l:count = 0
    let l:number_started = 0
    let l:space_after_number_started = 0
    for c in a:line
        if !l:number_started
            let l:count = l:count + 1
            if c!=' '
                let l:number_started = 1
            endif
        elseif !l:space_after_number_started
            let l:count = l:count + 1
            if c==' '
                let l:space_after_number_started = 1
            endif
        else "l:space_after_number_started = 1
            if c==' '
                let l:count = l:count + 1
            else
                break
            endif
        endif
    endfor
    return l:count
endfunction
