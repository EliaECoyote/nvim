vim.o.background = "dark"
vim.cmd("colorscheme default")

local accent = "DarkYellow"

vim.api.nvim_set_hl(0, "Normal", { ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { ctermbg = "NONE" })
vim.api.nvim_set_hl(0, "SignColumn", { ctermbg = "NONE" })

vim.api.nvim_set_hl(0, "Statement", { cterm = { bold = true } })
vim.api.nvim_set_hl(0, "Conditional", { ctermfg = accent })
vim.api.nvim_set_hl(0, "Repeat", { ctermfg = accent, cterm = { bold = true } })
vim.api.nvim_set_hl(0, "Structure", { ctermfg = accent })
vim.api.nvim_set_hl(0, "Define", { ctermfg = accent, cterm = { bold = true } })
vim.api.nvim_set_hl(0, "SpellRare", { cterm = { undercurl = true } })
vim.api.nvim_set_hl(0, "Function", { ctermfg = "DarkBlue" })
vim.api.nvim_set_hl(0, "Type", { ctermfg = "DarkMagenta" })
vim.api.nvim_set_hl(0, "Typedef", { ctermfg = "DarkMagenta" })
vim.api.nvim_set_hl(0, "DiffAdd", { ctermfg = "DarkGreen", cterm = { reverse = true } })
vim.api.nvim_set_hl(0, "DiffDelete", { ctermfg = "DarkRed", cterm = { reverse = true } })
vim.api.nvim_set_hl(0, "DiffChange", { ctermfg = "DarkYellow", cterm = { reverse = true } })
vim.api.nvim_set_hl(0, "DiffText", { ctermfg = "DarkGreen", cterm = { reverse = true, bold = true } })
vim.api.nvim_set_hl(0, "GitGutterAddLineNr", { ctermfg = "DarkGreen", cterm = { reverse = true } })
vim.api.nvim_set_hl(0, "GitGutterChangeLineNr", { ctermfg = "DarkYellow", cterm = { reverse = true } })
vim.api.nvim_set_hl(0, "GitGutterDeleteLineNr", { ctermfg = "DarkRed", cterm = { reverse = true } })
vim.api.nvim_set_hl(0, "Pmenu", { ctermbg = "Black" })
vim.api.nvim_set_hl(0, "PmenuSel", { ctermbg = "DarkGrey" })
