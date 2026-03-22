" Plugin configurations

function! LoadOutline()
lua << EOF
require("outline").setup({
    outline_window = {
        -- Where to open the split window: right/left
        position = 'right',

        -- Percentage or integer of columns
        width = 25,
        -- Whether width is relative to the total width of nvim
        -- When relative_width = true, this means take 25% of the total
        -- screen width for outline window.
        relative_width = true,

        -- Vim options for the outline window
        show_numbers = true,
        show_relative_numbers = true,
        wrap = true
    },
    symbol_folding = {
        markers = { '>', 'v' }
    },
    symbols = {
        -- You can use a custom function that returns the icon for each symbol kind.
        -- This function takes a kind (string) as parameter and should return an
        -- icon as string.
        ---@param kind string Key of the icons table below
        ---@param bufnr integer Code buffer
        ---@param symbol outline.Symbol The current symbol object
        ---@returns string|boolean The icon string to display, such as "f", or `false`
        ---                        to fallback to `icon_source`.
        --icon_fetcher = function (kind, bufnr, symbol) return "-" end,

        -- The next fallback if both icon_fetcher and icon_source has failed, is
        -- the custom mapping of icons specified below. The icons table is also
        -- needed for specifying hl group.
        icons = {
          File = { icon = 'f', hl = 'Identifier' },
          Module = { icon = 'M', hl = 'Include' },
          Namespace = { icon = 'n', hl = 'Include' },
          Package = { icon = 'p', hl = 'Include' },
          Class = { icon = 'C', hl = 'Type' },
          Method = { icon = 'm', hl = 'Function' },
          Property = { icon = 'p', hl = 'Identifier' },
          Field = { icon = 'f', hl = 'Identifier' },
          Constructor = { icon = 'c', hl = 'Special' },
          Enum = { icon = 'e', hl = 'Type' },
          Interface = { icon = 'I', hl = 'Type' },
          Function = { icon = 'f', hl = 'Function' },
          Variable = { icon = 'v', hl = 'Constant' },
          Constant = { icon = 'c', hl = 'Constant' },
          String = { icon = 's', hl = 'String' },
          Number = { icon = 'n', hl = 'Number' },
          Boolean = { icon = 'b', hl = 'Boolean' },
          Array = { icon = 'A', hl = 'Constant' },
          Object = { icon = 'O', hl = 'Type' },
          Key = { icon = 'k', hl = 'Type' },
          Null = { icon = 'NULL', hl = 'Type' },
          EnumMember = { icon = 'm', hl = 'Identifier' },
          Struct = { icon = 's', hl = 'Structure' },
          Event = { icon = 'e', hl = 'Type' },
          Operator = { icon = '+', hl = 'Identifier' },
          TypeParameter = { icon = 'T', hl = 'Identifier' },
          Component = { icon = 'C', hl = 'Function' },
          Fragment = { icon = 'F', hl = 'Constant' },
          TypeAlias = { icon = 'TA', hl = 'Type' },
          Parameter = { icon = 'p', hl = 'Identifier' },
          StaticMethod = { icon = 'sm ', hl = 'Function' },
          Macro = { icon = 'M', hl = 'Function' },
        },
    }
})
EOF
endfunction
call LoadOutline()

let s:outline_loaded=0
function! LoadOutlineOnUse()
    if s:outline_loaded==0
        call LoadOutline()
        let s:outline_loaded=1
    endif
endfunction
" Open Outline
nnoremap <silent> <localleader>o :call LoadOutlineOnUse() <bar> :Outline<cr>

function! LoadCopilot()
    packadd copilot.vim
    packadd plenary.nvim
    packadd CopilotChat.nvim
lua << EOF
    require("CopilotChat").setup {
        model = "claude-opus-4.6",
        window = {
            layout = 'vertical',
            width = 0.3,
        },
        mappings = {
            complete = {
                insert = ''
            }
        }
    }
EOF

    " Remap keyboard shortcuts for copilot.vim
    imap <silent><script><expr> <S-Tab> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:true
    inoremap <C-L> <Plug>(copilot-accept-word)

    " Remap keyboard shortcuts for CopilotChat.nvim
    nnoremap <leader>gg :CopilotChatToggle<CR>
    vnoremap <leader>gg :CopilotChatToggle<CR>
endfunction

command! LoadCopilot call LoadCopilot()

