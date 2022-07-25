require('user.plugins')

require('user.comment')
require('user.completion')
require('user.gitsigns')
require('user.keybindings')
require('user.lsp')
require('user.treesitter')

vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
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
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
  command = "set relativenumber",
  group = "NumberToggle"
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
  command = "set norelativenumber",
  group = "NumberToggle"
})

local colorcolumnValue = "+"
for i = 80, 999 do
  colorcolumnValue = colorcolumnValue .. i .. ","
end
vim.o.colorcolumn = colorcolumnValue

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

