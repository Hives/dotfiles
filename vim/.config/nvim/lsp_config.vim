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
  local on_attach = function(client)
    require'completion'.on_attach(client)
  end
  
  -- requires typescript to be installed - npm i -g typescript
  require'lspconfig'.tsserver.setup {
    on_attach = on_attach
  }

  require'lspconfig'.bashls.setup {
    on_attach = on_attach
  }

  require'lspconfig'.pyls.setup{
    on_attach = on_attach
  }

  -- require'lspconfig'.kotlin_language_server.setup {
  --   on_attach = on_attach,
  --   settings = {
  --     kotlin = {
  --       languageServer = {
  --         path = "/home/hives/.local/bin/kotlin-language-server/server/build/install/server/bin/kotlin-language-server"
  --       }
  --     }
  --   }
  -- }
EOF
