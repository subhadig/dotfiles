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

function! FormatTable()
    if getpos(".") < getpos("v")
        let l:header_row = getpos(".")
        let l:first_row = l:header_row + 2
        let l:last_row = getpos("v")
    elseif getpos(".") > getpos("v")
        let l:header_row = getpos("v")
        let l:first_row = l:header_row + 2
        let l:last_row = getpos(".")
    else
        throw "Multiline selection is expected for tables"
    endif

    let l:max_col_lengths = []
    for header in split(getline(l:header_row), "|")
        add(l:max_col_lengths, strcharlen(header))
    endfor

    for row in getline(l:first_row, l:last_row)
        let l:index = 0
        for column in split(row, "|")
            l:max_col_lengths[l:index] = max(l:max_col_lengths[l:index], column)
            let l:index = l:index + 1
        endfor
    endfor

    for header in getline(l:header_row)
        for column in split(header, "|")
    endfor
endfunction
