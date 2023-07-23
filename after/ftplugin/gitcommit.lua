vim.opt_local.textwidth = 72
vim.opt_local.colorcolumn = "+1"

-- Automatic formatting of paragraph while typing
vim.opt_local.formatoptions:append("a")
-- Trailing white space indicates that the paragraph continues in the next line
vim.opt_local.formatoptions:append("w")
