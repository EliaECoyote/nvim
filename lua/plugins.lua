-- tpope/vim-unimpaired
vim.g.nremap = {
  ["yo<Esc>"] = "<nop>",
  ["yo"] = "<nop>",
  [">p"] = "<nop>"
}

-- neovim/nvim-lspconfig
local constants_lsp = require("lib.constants_lsp")
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = constants_lsp.LSP_SERVERS
})
require("config_lsp")

-- jose-elias-alvarez/null-ls.nvim
require("config_null_ls")

-- airblade/vim-gitgutter
vim.o.updatetime = 100
vim.g.gitgutter_signs = 0
vim.g.gitgutter_highlight_linenrs = 1

-- nvim-treesitter/nvim-treesitter
require("config_treesitter")

-- j-hui/fidget.nvim
require("fidget").setup({})

-- ibhagwan/fzf-lua
local fzf = require("fzf-lua")
fzf.setup({
  winopts = {
    width     = 1,
    height    = 20,
    row       = 1,
    wrap      = 'wrap',
    on_create = function()
      vim.keymap.set("t", "<C-r>", [['<C-\><C-N>"'.nr2char(getchar()).'pi']], { expr = true, buffer = true })
    end
  },
  fzf_opts = {
    ["--keep-right"] = "",
    -- cf. https://github.com/ibhagwan/fzf-lua/wiki#custom-history
    ['--history'] = vim.fn.stdpath("data") .. "/fzf-lua-history",
  },
  files = { git_icons = false, file_icons = false },
  grep = { git_icons = false, file_icons = false },
  oldfiles = { cwd_only = true },
})
vim.keymap.set("n", "<leader>f?", fzf.builtin)
vim.keymap.set("n", "<C-t>", fzf.files, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>\\", fzf.buffers)
vim.keymap.set("n", "<leader><C-r>", fzf.oldfiles)
vim.keymap.set("n", "<leader>fr", fzf.resume)
vim.keymap.set("n", "<leader>ff", fzf.live_grep_glob)
vim.keymap.set("n", "<leader>fw", function()
  local BOOKMARKS_FOLDERS = {
    "~/.config/nvim/lua/",
    "~/.config/nvim/colors/",
    "~/.config/nvim/after/",
    "~/.config/nvim/syntax/",
    "~/.config/karabiner/",
    "~/.config/vifm/",
    "~/.config/doom/",
    "~/.local/bin/",
    "~/.github/",
    "~/Library/CloudStorage/Dropbox/",
    "~/dev/playground",
    "~/dev/notes",
  }
  local BOOKMARKS_FILES = {
    "~/.zshrc",
    "~/.bashrc",
    "~/.workrc",
    "~/.shellrc",
    "~/.ideavimrc",
    "~/.profile",
    "~/.bash_profile",
    "~/.gitconfig",
    "~/.gitignore",
    "~/.tmux.conf",
    "~/.wezterm.lua",
    "~/.config/nvim/init.lua",
    "~/.config/vifm/vifmrc",
    "~/.config/alacritty.toml",
    "~/.config/lazygit/config.yml",
    "~/.config/lazydocker/config.yml",
    "~/.config/karabiner/karabiner.json",
    "~/Brewfile",
  }
  fzf.files({
    prompt = "Bookmarks> ",
    cmd = "fd . "
        .. table.concat(BOOKMARKS_FOLDERS, " ")
        .. " | sed '1i\\\\n"
        .. table.concat(BOOKMARKS_FILES, "\\\n")
        .. "'"
  })
end)
fzf.register_ui_select(function(_, items)
  local min_h, max_h = 0.15, 0.70
  local h = (#items + 4) / vim.o.lines
  if h < min_h then
    h = min_h
  elseif h > max_h then
    h = max_h
  end
  return { winopts = { height = h, width = 0.60, row = 0.40 } }
end)
vim.keymap.set("n", "gr", fzf.lsp_references)
vim.keymap.set("n", "gd", fzf.lsp_definitions)

-- Autocompletion engine / sources / snippets.
require("config_cmp")

-- vim-test/vim-test
vim.g["test#strategy"] = "neovim"
-- Open terminal in normal mode, so it doesn't close on key press.
vim.g["test#neovim#start_normal"] = 1
-- When a new test run is requested, abort previous one.
vim.g["test#neovim_sticky#kill_previous"] = 1
-- When a new test run is requested, clear screen from previous run.
vim.g["test#preserve_screen"] = 0
-- Reopen terminal split if not visible
vim.g["test#neovim_sticky#reopen_window"] = 1

vim.keymap.set(
  "n",
  "t<C-d>",
  function()
    vim.g["test#go#runner"] = "delve"
    vim.cmd("TestNearest")
    vim.g["test#go#runner"] = nil
  end,
  {
    noremap = true,
    desc = "Debug nearest go test"
  }
)

vim.keymap.set(
  "n",
  "t<C-b>",
  function()
    local path = vim.fn.expand("%")
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]

    local tabpage = vim.api.nvim_get_current_tabpage()
    local windows = vim.api.nvim_tabpage_list_wins(tabpage)

    for _, win in ipairs(windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype == 'terminal' then
        local terminal_job_id = vim.b[buf].terminal_job_id
        if terminal_job_id then
          vim.fn.chansend(terminal_job_id, "b " .. path .. ":" .. curr_line)
          return
        end
      end
    end

    print("No terminal found")
  end,
  {
    noremap = true,
    desc = "Send delve breakpoint command to terminal"
  }
)
vim.keymap.set("n", "t<C-n>", ":TestNearest<cr>")
vim.keymap.set("n", "t<C-f>", ":TestFile<cr>")
vim.keymap.set("n", "t<C-l>", ":TestLast<cr>")

-- mfussenegger/nvim-dap
require("config_dap")

-- glacambre/firenvim
-- To build, run: vim.fn["firenvim#install"](0)
vim.g.firenvim_config = {
  globalSettings = { alt = "all" },
  localSettings = {
    [".*"] = {
      priority = 0,
      cmdline  = "neovim",
      content  = "text",
      takeover = "never",
      guifont  = "monospace:h50"
    }
  }
}
if vim.g.started_by_firenvim then
  vim.opt.guifont = "FiraMono Nerd Font Mono"
  vim.opt.laststatus = 0
end
