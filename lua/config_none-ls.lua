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
