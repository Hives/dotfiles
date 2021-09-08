nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

nnoremap <silent> gn    <cmd>lua vim.lsp.buf.rename()<CR>

noremap <silent> [g <cmd>vim.lsp.diagnostic.goto_prev()<CR>
noremap <silent> ]g <cmd>vim.lsp.diagnostic.goto_next()<CR>

lua <<EOF
  local function setup_servers()
    -- Register configs for installed servers in lspconfig.
    require'lspinstall'.setup()

    -- Get list of installed servers and then setup each
    -- server with lspconfig as usual.
    local servers = require'lspinstall'.installed_servers()
    for _, server in pairs(servers) do
      require'lspconfig'[server].setup{}
    end
  end

  setup_servers()

  -- automatically setup servers again after `:LspInstall <server>`
  require'lspinstall'.post_install_hook = function ()
    setup_servers() -- makes sure the new server is setup in lspconfig
    vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
  end
EOF
