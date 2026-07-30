" Plaintext specific settings

" Automatically inserts newline after 80 characters when typing in Insert mode
setlocal textwidth=80

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
    let l:output = add(l:output, slice(l:line, 0, -1))

    " Prepare the formatted data rows
    for row in getline(l:first_row_lnum, l:last_row_lnum)
        let l:cells = split(row, "|", 1)
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


function! s:yankReference()
    let init_cur_pos = getcurpos()

    " Go to the closing ] of the reference
    execute "normal" "$F]"
    
    " Yank the reference number with square braces, presumably at the end of
    " the line. e.g. [1]
    execute "normal" "v%y"

    " Go to the end of file
    execute "normal" "G"

    " Search with the yanked text
    call search(escape(getreg('0'), '['), 'b')

    " Yank the link
    execute "normal" 'WvE"+y'

    " Put the cursor back to the initial position
    call setpos('.', init_cur_pos)
endfunction


" TODO: Handle when unused references are present under REFERENCES section
" TODO: Remove textwidth hardcoding
function! RearrangeReferences() abort
    let init_cur_pos = getcurpos()

    " Set cursor to the beginning of the file
    call setpos('.', [0, 1, 1, 0])
    
    " Get the REFERENCES header line no
    let [ref_head_line, _] = searchpos('REFERENCES', 'n')

    " Create a list of all references used
    let references_list = []
    while 1
        let [line, col] = searchpos('[\d\+\]', 'W', ref_head_line)
        if line == 0
            break
        endif
        execute "normal" 'lyt]'
        call add(references_list, [getreg('0'), line, col, ''])
    endwhile

    " Set the cursor to the REFERENCES header line
    call setpos('.', [0, ref_head_line, 1, 0])

    " Add the urls information to references_list
    while 1
        let line = search('[\d\+\]', 'W')
        if line == 0
            break
        endif
        execute "normal" 'l"ayt]'
        execute "normal" 'W"byE]'
        for ref in references_list
            if ref[0] == getreg('a')
                let ref[3] = getreg('b')
                break
            endif
        endfor
    endwhile
   
    " Now regenerate the references numbers
    let ref_index = 1
    for [_, line, col, url] in references_list
        call setpos('.', [0, line, col + 1, 0])
        execute "normal" 'ct]' . ref_index
        let ref_index = ref_index + 1
    endfor

    " Set the cursor to the REFERENCES content start line
    call setpos('.', [0, ref_head_line + 2, 1, 0])

    " Regenerate the REFERENCES section
    let ref_index = 1
    setlocal textwidth=0
    for [_, _, _, url] in references_list
        execute "normal" 'j0C[' . ref_index . '] ' . url
        let ref_index = ref_index + 1
    endfor
    setlocal textwidth=80

    " Put the cursor back to the initial position
    call setpos('.', init_cur_pos)
endfunction


" Key bindings

"" Table
vnoremap <buffer> <leader>mtf :call FormatTable()<cr>

"" Underline
nnoremap <buffer> <localleader>mU :call Underline("=")<CR>
nnoremap <buffer> <localleader>mu :call Underline("-")<CR>

"" Yank reference link
nnoremap <buffer> <localleader>mly :call <SID>yankReference()<CR>

"" Convert markdown link to reference
nnoremap <buffer> <localleader>mlc ^wxf]s<Space><Esc>lxdt)maGA<CR>[]<Space><Esc>p^klyi[ji<C-r>=<C-r>0+1<CR><Esc>ByE`a$vp
