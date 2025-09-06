-- Saves undo history to a file stored in `:h undodir`.
vim.o.undofile = true

-- Refresh file every time you access the buffer.
-- This is useful to sync buffer when it has changed on disk.
vim.api.nvim_create_autocmd({ "FocusGained" }, {
  callback = function()
    -- To ignore cmd line / popover buffers
    if vim.bo.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
})

-- Enables mouse visual selection.
vim.o.mouse = "a"

-- Enables Vim per-project configuration files.
vim.o.exrc = true
vim.o.secure = true

vim.filetype.add({
  -- Sets filetypes based on file extension.
  extension = { mdx = "mdx" }
})

-- Autocomplete
vim.o.completeopt = "menu,menuone,noinsert,popup,fuzzy"
vim.o.cia = "kind,abbr,menu"

vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.grepformat = "%f:%l:%c:%m,%f:%l:%m"

-- Hides netrw banner.
vim.g.netrw_banner = 0
-- Fixes buggy netrw buffers not closing behavior:
-- https://github.com/tpope/vim-vinegar/issues/13#issuecomment-489440040
vim.g.netrw_fastbrowse = 0
-- Fixes netrw buffers with empty % register:
-- https://github.com/neovim/neovim/issues/17841#issuecomment-1077604089
vim.o.hidden = false

vim.o.updatetime = 200

-- See https://github.com/neovim/nvim-lspconfig/tree/master/lsp for configurations.
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

require("keymaps")
require("theme")
require("plugins")
