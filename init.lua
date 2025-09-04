-- Save undo history to a file stored in `:h undodir`
vim.o.undofile = true

-- Refresh file every time you access the buffer.
-- This is useful to sync buffer when it has changed on disk.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    -- To ignore cmd line buffers
    if vim.bo.buftype == "" then
      vim.cmd.checktime()
    end
  end,
})

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
vim.lsp.enable({
  "vtsls",
  "html",
  "cssls",
  "basedpyright",
  "ruff",
  "eslint",
  "lua_ls",
  "bashls",
  "jsonls",
  "gopls",
  "cmake",
  "terraformls",
  "yamlls",
})

require("plugins")
