local utils_lsp = require("lib.utils_lsp")
local constants_lsp = require("lib.constants_lsp")

for _, lsp in ipairs(constants_lsp.LSP_SERVERS) do
  vim.lsp.enable(lsp)
end
