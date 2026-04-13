" Plaintext specific settings

" Automatically inserts newline after 80 characters when typing in Insert mode
set textwidth=80

" Evaluated to get the proper indent for a line
setlocal indentexpr=CustomPlaintextIndent()

function! CustomPlaintextIndent()
    let l:prev_line=getline(v:lnum - 1)
     " If the line is the starting of a bullet or numbered list
    if l:prev_line=~'^\s*[-*+] .*' || l:prev_line=~'^\s*[0-9a-z]*[.)] .*'
        return Get_starting_space_count(l:prev_line)
    else
        return -1
    endif
endfunction

" TODO: Remove this function
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

function! FormatTable() range
    let l:header_row_lnum = getpos("'<")[1]
    let l:first_row_lnum = l:header_row_lnum + 2
    let l:last_row_lnum = getpos("'>")[1]

    " Get column-lengths for the headers
    let l:max_col_lengths = []
    for header in split(getline(l:header_row_lnum), "|")
        let l:max_col_lengths = add(l:max_col_lengths, strcharlen(trim(header)))
    endfor

    " Get max column-lengths for all data rows
    for row in getline(l:first_row_lnum, l:last_row_lnum)
        let l:index = 0
        for column in split(row, "|")
            let l:max_col_lengths[l:index] = max([l:max_col_lengths[l:index], strcharlen(trim(column))])
            let l:index = l:index + 1
        endfor
    endfor

    let l:output = []

    " Prepare the formatted header row
    let l:line = ""
    let l:headers = split(getline(l:header_row_lnum), "|")
    let l:col_index = 0
    for max_col_length in l:max_col_lengths
        let l:trimmed_header = trim(l:headers[l:col_index])
        let l:line = l:line . " " . l:trimmed_header
        let l:additional_spaces = max_col_length - strcharlen(l:trimmed_header)
        while l:additional_spaces > 0
            let l:line = l:line . " "
            let l:additional_spaces = l:additional_spaces - 1
        endwhile
        let l:line = l:line . " |"
        let l:col_index = l:col_index + 1
    endfor
    let l:output = add(l:output, slice(l:line, 0, -2))

    " Prepare the formatted header border
    let l:line = ""
    for max_col_length in l:max_col_lengths
        let l:index = 0
        let l:line = l:line . "-"
        while l:index < max_col_length
            let l:line = l:line . "-"
            let l:index = l:index + 1
        endwhile
        let l:line = l:line . "-|"
    endfor
    let l:output = add(l:output, slice(l:line, 0, -2))

    " Prepare the formatted data rows
    for row in getline(l:first_row_lnum, l:last_row_lnum)
        let l:cells = split(row, "|")
        let l:col_index = 0
        let l:line = ""
        for max_col_length in l:max_col_lengths
            let l:trimmed_cell = trim(l:cells[l:col_index])
            let l:line = l:line . " " . l:trimmed_cell
            let l:additional_spaces = max_col_length - strcharlen(l:trimmed_cell)
            while l:additional_spaces > 0
                let l:line = l:line . " "
                let l:additional_spaces = l:additional_spaces - 1
            endwhile
            let l:line = l:line . " |"
            let l:col_index = l:col_index + 1
        endfor
        let l:output = add(l:output, slice(l:line, 0, -2))
    endfor

    " Write the table to buffer
    call setline(l:header_row_lnum, l:output)
endfunction


" Key bindings

"" Table
vnoremap <leader>mft :call FormatTable()<cr>

"" Underline
nnoremap <localleader>mU :call Underline("=")<CR>
nnoremap <localleader>mu :call Underline("-")<CR>
