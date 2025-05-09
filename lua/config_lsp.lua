local constants_lsp = require("lib.constants_lsp")

-- See https://github.com/neovim/nvim-lspconfig/tree/master/lsp for configurations
for _, lsp in ipairs(constants_lsp.LSP_SERVERS) do
  vim.lsp.enable(lsp)
end
