local cmd_resolver = require("null-ls.helpers.command_resolver")
local null_ls = require("null-ls")


null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier.with({
      timeout = 8000,
      dynamic_command = function(params)
        return cmd_resolver.from_yarn_pnp()(params)
            or cmd_resolver.from_node_modules()(params)
            or vim.fn.executable(params.command) == 1 and params.command
      end,
      filetypes = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "graphql",
        "handlebars",
      },
    }),
    null_ls.builtins.formatting.sqlfluff,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.terraform_fmt,
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.buildifier,
    null_ls.builtins.formatting.buildifier,
  },
})
