-- Save undo history to a file stored in `:h undodir`
vim.o.undofile = true

-- Refresh file every time you access the buffer.
-- This is useful to sync buffer when it has changed on disk.
vim.cmd [[
  au FocusGained,BufEnter * :checktime
]]

-- Enable mouse visual selection
vim.o.mouse = "a"

-- Enables Vim per-project configuration files
vim.o.exrc = true
vim.o.secure = true

vim.filetype.add({
  -- Sets filetypes based on file extension.
  extension = { mdx = "mdx" }
})

-- Autocomplete
vim.o.completeopt = "menu,menuone,noinsert,popup,fuzzy"
vim.o.cia = "kind,abbr,menu"

vim.o.updatetime = 200

require("config_keymaps")
require("config_theme")
require("config_search_and_replace")

-- See https://github.com/neovim/nvim-lspconfig/tree/master/lsp for configurations
local constants_lsp = require("lib.constants_lsp")
for _, lsp in ipairs(constants_lsp.LSP_SERVERS) do
  vim.lsp.enable(lsp)
end

require("plugins")
