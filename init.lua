-- Save undo history to a file stored in `:h undodir`
vim.g.undofile = true

-- Refresh file every time you access the buffer.
-- This is useful to sync buffer when it has changed on disk.
vim.cmd [[
  au FocusGained,BufEnter * :checktime
]]

-- Enable mouse visual selection
vim.g.mouse = "a"

-- Enables Vim per-project configuration files
vim.g.exrc = true

-- Prevent :autocmd, shell and write commands from being run
-- inside project-specific .vimrc files unless they’re owned by you.
vim.g.secure = true

vim.filetype.add({
  -- Sets filetypes based on file extension.
  extension = { mdx = "mdx" }
})

require("config_keymaps")
require("config_theme")
require("config_search_and_replace")

-- See https://github.com/neovim/nvim-lspconfig/tree/master/lsp for configurations
local constants_lsp = require("lib.constants_lsp")
for _, lsp in ipairs(constants_lsp.LSP_SERVERS) do
  vim.lsp.enable(lsp)
end

require("plugins")
