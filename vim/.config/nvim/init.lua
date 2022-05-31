require('plugins')
require('keybindings')

local function blahdeblah()
    print "hello world\n"
end

vim.bo.expandtab = true
vim.bo.tabstop = 4       -- number of visual spaces per tab
vim.bo.softtabstop = 4   -- number of spaces in tab when editing
vim.bo.shiftwidth = 4

-- COLORSCHEME
vim.api.nvim_exec([[
let base16colorspace=256
colorscheme base16-default-dark
]], false)

vim.api.nvim_exec([[
" LIGHTLINE
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

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true

-- what is this??
vim.o.showcmd = true

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

local configs = require'nvim-treesitter.configs'
configs.setup {
    ensure_installed = "all",
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    }
}

local lsp_installer = require("nvim-lsp-installer")
lsp_installer.on_server_ready(function(server)
    local opts = {}
    if server.name == "sumneko_lua" then
        blahdeblah()
        opts = {
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim', 'use' }
                    },
                }
            }
        }
    end
    server:setup(opts)
end)

local cmp = require'cmp'
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    -- Accept currently selected item. Set `select` to `false` to only
    -- confirm explicitly selected items.
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['sumneko_lua'].setup {
  capabilities = capabilities
}
