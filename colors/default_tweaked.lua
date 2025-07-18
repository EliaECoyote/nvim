vim.cmd("colorscheme default")

local accent = "DarkMagenta"

vim.api.nvim_set_hl(0, "Define", { fg = accent })
vim.api.nvim_set_hl(0, "Conditional", { fg = accent })
vim.api.nvim_set_hl(0, "Define", { fg = accent, bold = true })
vim.api.nvim_set_hl(0, "Keyword", { fg = accent, italic = true })
vim.api.nvim_set_hl(0, "Repeat", { fg = accent, bold = true })
vim.api.nvim_set_hl(0, "Structure", { fg = accent, bold = true })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = accent })
vim.api.nvim_set_hl(0, "Function", { fg = "Blue" })
vim.api.nvim_set_hl(0, "Type", { fg = "DarkCyan" })
vim.api.nvim_set_hl(0, "Typedef", { fg = "DarkCyan" })
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "LightGreen" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "LightRed" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "LightYellow" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "LightYellow", bold = true })
vim.api.nvim_set_hl(0, "GitGutterAddLineNr", { fg = "Green", bg = "LightGreen", bold = true })
vim.api.nvim_set_hl(0, "GitGutterChangeLineNr", { fg = "DarkYellow", bg = "LightYellow", bold = true })
vim.api.nvim_set_hl(0, "GitGutterDeleteLineNr", { fg = "Red", bg = "LightRed", bold = true })
