local configs = require("nvim-treesitter.configs")

configs.setup({
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

require("treesitter-context").setup({
  max_lines = 3,
  min_window_height = 40,
  multiline_threshold = 1,
  multiwindow = true,
  patterns = {
    yaml = {
      "block_mapping_pair",
      "block_sequence_item",
    },
  }
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

-- Adopt markdown highlights for mdx files.
-- vim.treesitter.language.register("mdx", "markdown")
