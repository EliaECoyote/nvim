vim.o.background = "dark"
vim.cmd("colorscheme default")

local accent = "#c78a5e"

vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })

vim.api.nvim_set_hl(0, "Conditional", { fg = accent })
vim.api.nvim_set_hl(0, "Define", { fg = accent, bold = true })
vim.api.nvim_set_hl(0, "Keyword", { fg = accent, italic = true })
vim.api.nvim_set_hl(0, "Repeat", { fg = accent, bold = true })
vim.api.nvim_set_hl(0, "Structure", { fg = accent, bold = true })
vim.api.nvim_set_hl(0, "SpellRare", { undercurl = true, sp = accent })
vim.api.nvim_set_hl(0, "Function", { fg = "#6e9cc8" })
vim.api.nvim_set_hl(0, "Type", { fg = "#a07ab8" })
vim.api.nvim_set_hl(0, "Typedef", { fg = "#a07ab8" })
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1E4B18" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4B1818" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1E4B18" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#1E4B18", bold = true })
vim.api.nvim_set_hl(0, "GitGutterAddLineNr", { fg = "#b3f6c0", bg = "#1E4B18", bold = true })
vim.api.nvim_set_hl(0, "GitGutterChangeLineNr", { fg = "#fce094", bg = "#6b5300", bold = true })
vim.api.nvim_set_hl(0, "GitGutterDeleteLineNr", { fg = "#ffc0b9", bg = "#4B1818", bold = true })
