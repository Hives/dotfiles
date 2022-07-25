require('user.plugins')

require('user.keybindings')
require('user.comment')
require('user.treesitter')
require('user.completion')
require('user.gitsigns')

vim.o.number = true
vim.o.relativenumber = true
-- vim.o.cursorline = true
vim.o.scrolloff = 8

vim.o.showcmd = true

vim.wo.signcolumn = "yes"

vim.api.nvim_exec([[
  " to make vim commit messages wrap?
  filetype indent plugin on
]], false)

-- COLORSCHEME
vim.api.nvim_exec([[
  let base16colorspace=256
  colorscheme base16-default-dark
]], false)

-- LIGHTLINE
vim.api.nvim_exec([[
" append * for 'changes need saving' to the filename
function! LightlineFilename()
  let modified = &modified ? ' *' : ''
  let filename = expand('%:t') !=# '' ? expand('%:t') : '[No Name]'
  return filename . modified
endfunction

set noshowmode " hide --INSERT--, not required with coloured status bar
let g:lightline = {
      \   'colorscheme': 'base16',
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'readonly', 'filename' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'percent' ],
      \                [ 'filetype' ] ],
      \   },
      \   'inactive': {
      \     'left': [ [ 'readonly', 'filename' ] ],
      \     'right': [ [ 'lineinfo' ],
      \                [ 'percent' ],
      \                [ 'filetype' ] ],
      \   },
      \   'component_function': {
      \     'filename': 'LightlineFilename',
      \   },
      \ }
]], false)

vim.api.nvim_create_augroup("NumberToggle", { clear = false })
vim.api.nvim_create_autocmd( {"BufEnter", "FocusGained", "InsertLeave"}, {
    command = "set relativenumber",
    group = "NumberToggle"
})
vim.api.nvim_create_autocmd( {"BufLeave", "FocusLost", "InsertEnter"}, {
    command = "set norelativenumber",
    group = "NumberToggle"
})

local colorcolumnValue = "+"
for i=80,999 do
    colorcolumnValue = colorcolumnValue .. i .. ","
end
vim.o.colorcolumn = colorcolumnValue

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]tion')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gr', require('telescope.builtin').lsp_references)
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', vim.lsp.buf.format or vim.lsp.buf.formatting, { desc = 'Format current buffer with LSP' })
end

-- nvim-cmp supports additional completion capabilities
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable the following language servers
local servers = { 'pyright', 'tsserver', 'sumneko_lua' }

-- Ensure the servers above are installed
require('nvim-lsp-installer').setup {
  ensure_installed = servers,
}

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

require('lspconfig').sumneko_lua.setup {
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'}
      }
    }
  }
}
