vim.o.background = "dark"
vim.cmd("colorscheme default")

local accent = "DarkYellow"
local gui_accent = "#fce094"

vim.api.nvim_set_hl(0, "Normal", { ctermbg = "NONE", bg = "#18263B" })
vim.api.nvim_set_hl(0, "NormalFloat", { ctermbg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { ctermbg = "NONE", bg = "NONE" })

vim.api.nvim_set_hl(0, "Statement", { cterm = { bold = true }, bold = true })
vim.api.nvim_set_hl(0, "Conditional", { ctermfg = accent, fg = gui_accent })
vim.api.nvim_set_hl(0, "Repeat", { ctermfg = accent, cterm = { bold = true }, fg = gui_accent, bold = true })
vim.api.nvim_set_hl(0, "Structure", { ctermfg = accent, fg = gui_accent })
vim.api.nvim_set_hl(0, "Define", { ctermfg = accent, cterm = { bold = true }, fg = gui_accent, bold = true })
vim.api.nvim_set_hl(0, "SpellRare", { cterm = { undercurl = true }, undercurl = true })
vim.api.nvim_set_hl(0, "Function", { ctermfg = "DarkBlue", fg = "#a6dbff" })
vim.api.nvim_set_hl(0, "Type", { ctermfg = "DarkMagenta", fg = "#ffcaff" })
vim.api.nvim_set_hl(0, "Typedef", { ctermfg = "DarkMagenta", fg = "#ffcaff" })
vim.api.nvim_set_hl(0, "DiffAdd", { ctermfg = "DarkGreen", cterm = { reverse = true }, fg = "#b3f6c0", reverse = true })
vim.api.nvim_set_hl(0, "DiffDelete", { ctermfg = "DarkRed", cterm = { reverse = true }, fg = "#ffc0b9", reverse = true })
vim.api.nvim_set_hl(0, "DiffChange", { ctermfg = "DarkYellow", cterm = { reverse = true }, fg = "#fce094", reverse = true })
vim.api.nvim_set_hl(0, "DiffText", { ctermfg = "DarkGreen", cterm = { reverse = true, bold = true }, fg = "#b3f6c0", reverse = true, bold = true })
vim.api.nvim_set_hl(0, "GitGutterAddLineNr", { ctermfg = "DarkGreen", cterm = { reverse = true }, fg = "#b3f6c0", reverse = true })
vim.api.nvim_set_hl(0, "GitGutterChangeLineNr", { ctermfg = "DarkYellow", cterm = { reverse = true }, fg = "#fce094", reverse = true })
vim.api.nvim_set_hl(0, "GitGutterDeleteLineNr", { ctermfg = "DarkRed", cterm = { reverse = true }, fg = "#ffc0b9", reverse = true })
vim.api.nvim_set_hl(0, "Pmenu", { ctermbg = "Black", bg = "#07080d" })
vim.api.nvim_set_hl(0, "PmenuSel", { ctermbg = "DarkGrey", bg = "#4f5258" })
