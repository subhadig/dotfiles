-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

local lspconfig = require('lspconfig')
local coq = require('coq')

local servers = {'jedi_language_server', 'clangd'}

for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup{
        coq.lsp_ensure_capabilities{
            flags = lsp_flags
        }
    }
    lspconfig[lsp].setup{
        on_attach = on_attach,
        flags = lsp_flags
    }
end

local function setup_outline()
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
        }
    })
end

-- Define a function that sets up the timer.
local function delayed_task()
  -- Create a new libuv timer.
  local timer = vim.loop.new_timer()
  
  -- Start the timer.
  -- The first argument is the delay in milliseconds (e.g., 2000 for 2 seconds).
  -- The second argument is the repeat interval (0 for single-shot).
  -- The third argument is the function to execute.
  -- We wrap the function with vim.schedule_wrap to ensure it's called on the main event loop.
  timer:start(2000, 0, vim.schedule_wrap(setup_outline))
end

-- Call the function to set up the timer in your init.lua.
delayed_task()
