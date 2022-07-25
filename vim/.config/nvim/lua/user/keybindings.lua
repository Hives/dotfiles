vim.g.mapleader = " "

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

local function nkeymap(key, map)
    keymap('n', key, map, opts)
end

local function vkeymap(key, map)
    keymap('v', key, map, opts)
end


nkeymap('<leader>w', ':w<cr>')
nkeymap('<leader>q', ':q<cr>')

-- open netrw file browser in vertical split
nkeymap('<leader>pv', ':Vex<CR>')
nkeymap('<leader>ph', ':Hex<CR>')

nkeymap('<leader><CR>', ':so ~/.config/nvim/init.lua<CR>')

-- make Ctrl-C copy to both x clipboard and primary selection
-- requires gvim to be installed?!
-- see https://www.youtube.com/watch?v=E_rbfQqrm7g
vkeymap('<c-c>', '"*y :let @+=@*<CR>')

nkeymap('<leader>t', [[<cmd>lua require('telescope.builtin').find_files()<cr>]])
nkeymap('<leader>f', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]])
nkeymap('<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<cr>]])
nkeymap('<leader>h', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]])

nkeymap('gd', ':lua vim.lsp.buf.definition()<cr>')
nkeymap('gD', ':lua vim.lsp.buf.declaration()<cr>')
nkeymap('gi', ':lua vim.lsp.buf.implementation()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.document_symbol()<cr>')
nkeymap('gw', ':lua vim.lsp.buf.workspace_symbol()<cr>')
nkeymap('gr', ':lua vim.lsp.buf.references()<cr>')
nkeymap('gt', ':lua vim.lsp.buf.type_definition()<cr>')
nkeymap('K', ':lua vim.lsp.buf.hover()<cr>')
nkeymap('<c-k>', ':lua vim.lsp.buf.signature_help()<cr>')
nkeymap('<leader>af', ':lua vim.lsp.buf.code_action()<cr>')
nkeymap('<leader>rn', ':lua vim.lsp.buf.rename()<cr>')

nkeymap('<leader>r', ':lua vim.lsp.buf.formatting_sync()<cr>')
