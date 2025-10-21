-- https://github.com/nvimtools/none-ls.nvim
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.diagnostics.buildifier,
    null_ls.builtins.formatting.buildifier,
  },
})

-- https://github.com/saghen/blink.cmp
local blink = require("blink.cmp")
-- Refer to https://cmp.saghen.dev/configuration/reference.html for defaults.
blink.setup({
  fuzzy = {
    implementation = "prefer_rust",
    prebuilt_binaries = { force_version = "v1.6.0" }
  },
  keymap = {
    preset = "default",
    ["<C-space>"] = false,
  },
  completion = {
    menu = { border = "none" },
    list = { selection = { preselect = false, auto_insert = true } },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 1500,
    },
  },
  cmdline = {
    enabled = false,
  },
})
vim.keymap.set("i", "<C-x><C-o>", blink.show)

-- https://github.com/airblade/vim-gitgutter
vim.g.gitgutter_signs = 0
vim.g.gitgutter_highlight_linenrs = 1

-- https://github.com/nvim-treesitter/nvim-treesitter
local treesitter_configs = require("nvim-treesitter.configs")

treesitter_configs.setup({
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(_, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 5000
    end,
    -- Required for spellcheck, some LaTex highlights and
    -- code block highlights that do not have ts grammar
    additional_vim_regex_highlighting = { "org" },
  },
  indent = {
    enable = true,
    -- Waiting for better treesitter indents for python:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
    disable = { "python" },
  },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- https://github.com/j-hui/fidget.nvim
require("fidget").setup({})

-- https://github.com/ibhagwan/fzf-lua
local fzf = require("fzf-lua")
fzf.setup({
  silent = true,
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
  keymap = {
    builtin = {
      true,
      ["<M-Right>"] = false,
      ["M-Right"] = false,
      ["M-<Right>"] = false,
    }
  },
  global = {
    git_icons = false,
    silent = true,
    keymap = {
      builtin = {
        true,
        ["M-<Right>"] = false,
      }
    },
  },
  oldfiles = { cwd_only = true, include_current_session = true, silent = true },
  live_grep = { silent = true },
  finder = { silent = true }
})

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

vim.keymap.set("n", "<leader>f?", fzf.builtin)
vim.keymap.set("n", "<C-t>", fzf.global)
vim.keymap.set("n", "<leader>\\", fzf.buffers)
vim.keymap.set("n", "<leader><C-r>", fzf.oldfiles)
vim.keymap.set("n", "<leader>fr", fzf.resume)
vim.keymap.set("n", "<leader>ff", fzf.live_grep)
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
vim.keymap.set("n", "grr", fzf.lsp_references)
vim.keymap.set("n", "gd", fzf.lsp_definitions)
vim.keymap.set("n", "gra", fzf.lsp_code_actions)
vim.keymap.set("n", "gri", fzf.lsp_implementations)
vim.keymap.set("n", "grs", fzf.lsp_document_symbols)
vim.keymap.set("n", "<A-c>", function()
  fzf.files({
    fd_opts = "--type d --hidden --exclude .git",
    prompt  = "dirs> ",
    actions = {
      ["default"] = function(selected)
        local dir = selected and selected[1]
        if dir and #dir > 0 then
          vim.cmd("tcd " .. vim.fn.fnameescape(dir))
        end
      end,
    },
  })
end, { desc = "fzf_cd into :tcd" })

-- https://github.com/vim-test/vim-test
vim.g["test#strategy"] = "neovim"
-- Open terminal in normal mode, so it doesn't close on key press.
vim.g["test#neovim#start_normal"] = 1
-- When a new test run is requested, abort previous one.
vim.g["test#neovim_sticky#kill_previous"] = 1
-- When a new test run is requested, clear screen from previous run.
vim.g["test#preserve_screen"] = 0
-- Reopen terminal split if not visible
vim.g["test#neovim_sticky#reopen_window"] = 1

vim.keymap.set("n", "<leader>tt", ":TestNearest<cr>")
vim.keymap.set("n", "<leader>tf", ":TestFile<cr>")
vim.keymap.set("n", "<leader>tl", ":TestLast<cr>")
vim.keymap.set(
  "n",
  "<leader>td",
  function()
    vim.g["test#go#runner"] = "delve"
    vim.cmd("TestFile")
    vim.g["test#go#runner"] = nil
  end,
  {
    noremap = true,
    desc = "Debug nearest go test."
  }
)
vim.keymap.set(
  "n",
  "<leader>tb",
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
          vim.fn.chansend(terminal_job_id, "b " .. path .. ":" .. curr_line .. "\n")
          return
        end
      end
    end

    print("No terminal found")
  end,
  {
    noremap = true,
    desc = "Send delve breakpoint command to terminal."
  }
)

-- https://github.com/glacambre/firenvim
--
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
