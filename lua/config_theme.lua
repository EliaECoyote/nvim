-- Temporarily highlights yanked region after each yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Undercurl support
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

vim.go.background = "light"
vim.cmd.colorscheme("default_tweaked")

-- Winborder style
vim.o.winborder = "solid"

-- Global statusline
vim.opt.laststatus = 3

-- Indentation settings
vim.cmd("filetype plugin indent on")
vim.opt.autoindent = true

-- Always display signcolumn with width 1
vim.opt.signcolumn = "yes:1"

-- Hide netrw banner
vim.g.netrw_banner = 0
-- Fix buggy netrw buffers not closing behavior
-- https://github.com/tpope/vim-vinegar/issues/13#issuecomment-489440040
vim.g.netrw_fastbrowse = 0
-- Fix netrw buffers with empty % register
-- https://github.com/neovim/neovim/issues/17841#issuecomment-1077604089
vim.opt.hidden = false

-- Use spaces instead of tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Case options
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Enables text wrap
vim.opt.linebreak = true
vim.opt.wrap = true

-- Disables hard-wrap
vim.opt.textwidth = 0

-- Unfold by default
vim.opt.foldenable = false

-- Makes vimdiff easier to read
vim.opt.diffopt:append("vertical")

vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true

-- Disable redundant messages from ins-completion-menu
vim.opt.shortmess:append("c")
-- Disable intro message
vim.opt.shortmess:append("I")

-- Use default cursor in insert mode
vim.opt.guicursor = ""

-- Highlights end-of-line
vim.opt.list = true
vim.opt.listchars = { tab = "▶ ", trail = "•", precedes = "<", extends = ">" }

vim.g.markdown_fenced_languages = {
  "html",
  "python",
  "lua",
  "vim",
  "typescript",
  "javascript",
}

function _G.custom_status_line()
  local file_name = "%-.16t"
  local modified = "%-m"
  local file_type = "%y"
  local space_middle = "%="

  local counts = { 0, 0, 0, 0 }
  for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
    counts[diagnostic.severity] = counts[diagnostic.severity] + 1
  end

  local lsp_segment = ''
  local severity_labels = { 'Error', 'Warn', 'Info', 'Hint' }
  for severity_index, count in ipairs(counts) do
    if count > 0 then
      local type = severity_labels[severity_index]
      lsp_segment = string.format(
        '%s%%#StatusLineLsp%s# %d%s ',
        lsp_segment,
        type,
        count,
        type:sub(0, 1)
      )
    end
  end

  return string.format(
    "%s %s %s %%#StatusLine# %s %s",
    file_name,
    modified,
    lsp_segment,
    space_middle,
    file_type
  )
end

vim.opt.statusline = "%!v:lua.custom_status_line()"
