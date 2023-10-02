-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Heuristically set buffer options
    "tpope/vim-sleuth",
    -- Adds comments with `gc`
    "tpope/vim-commentary",
    -- Git wrapper
    "tpope/vim-fugitive",
    -- Netrw improvements
    "tpope/vim-vinegar",
    -- Handy bracket mappings
    {
      "tpope/vim-unimpaired",
      init = function()
        vim.g.nremap = {
          ["yo<Esc>"] = "<nop>",
          ["yo"] = "<nop>",
          [">p"] = "<nop>"
        }
      end
    },
    -- LSP goodies
    {
      "neovim/nvim-lspconfig",
      dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
      config = function()
        local constants_lsp = require("lib.constants_lsp")
        require("mason").setup()
        require("mason-lspconfig").setup({
          ensure_installed = constants_lsp.LSP_SERVERS
        })
        require("config_lsp")
      end
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function() require("config_null_ls") end
    },
    {
      "lewis6991/gitsigns.nvim",
      name = "gitsigns",
      opts = {
        signcolumn      = false,
        numhl           = true,
        max_file_length = 1000,
        on_attach       = function(bufnr)
          local gs = package.loaded.gitsigns
          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { buffer = bufnr, expr = true })
          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { buffer = bufnr, expr = true })
        end
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ":TSUpdate",
      config = function() require("config_treesitter") end
    },
    {
      "j-hui/fidget.nvim",
      tag = "legacy",
      name = "fidget",
      opts = { text = { spinner = "dots" } },
    },
    {
      "machakann/vim-sandwich",
      config = function()
        -- Use vim-surround keybindings to avoid replacing `s`:
        -- https://github.com/machakann/vim-sandwich/wiki/Introduce-vim-surround-keymappings
        vim.cmd [[
          runtime macros/sandwich/keymap/surround.vim
        ]]
      end
    },
    {
      "ibhagwan/fzf-lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
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
        })
        vim.keymap.set("n", "<leader>f?", fzf.builtin)
        vim.keymap.set("n", "<leader>p", fzf.files)
        vim.keymap.set("n", "<leader>\\", fzf.buffers)
        vim.keymap.set("n", "<leader>fo", fzf.oldfiles)
        vim.keymap.set("n", "<leader>fr", fzf.resume)
        vim.keymap.set("n", "<leader>ff", fzf.live_grep_glob)
        vim.keymap.set("n", "<leader>fw", function()
          local BOOKMARKS_FOLDERS = {
            "~/.config/nvim/",
            "~/.config/karabiner/",
            "~/.config/vifm/",
            "~/.config/doom/",
            "~/.local/bin/",
            "~/.github/",
            "~/Library/CloudStorage/Dropbox/",
            "~/dev/playground",
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
      end
    },
    -- Autocompletion engine / sources / snippets.
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        -- Neovim Lua apis autocomplete.
        "hrsh7th/cmp-nvim-lua",
        -- LuaSnip integration.
        "saadparwaiz1/cmp_luasnip",
        -- Snippet engine
        "L3MON4D3/LuaSnip",
        -- Snippets library
        "rafamadriz/friendly-snippets",
      },
      config = function() require("config_cmp") end
    },
    -- Open current line on github
    "ruanyl/vim-gh-line",
    {
      "vim-test/vim-test",
      config = function()
        vim.g["test#strategy"] = "neovim"
        vim.keymap.set("n", "t<C-n>", ":TestNearest<cr>")
        vim.keymap.set("n", "t<C-f>", ":TestFile<cr>")
        vim.keymap.set("n", "t<C-l>", ":TestLast<cr>")
      end
    },
    {
      "mfussenegger/nvim-dap",
      config = function() require("config_dap") end
    },
    {
      "glacambre/firenvim",
      -- Lazy load firenvim
      -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
      lazy = not vim.g.started_by_firenvim,
      build = function()
        vim.fn["firenvim#install"](0)
      end,
      config = function()
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
      end
    },
  },
  {
    defaults = { lazy = false },
  })
