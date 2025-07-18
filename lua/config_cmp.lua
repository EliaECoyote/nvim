local cmp = require("cmp")

vim.opt.completeopt = { "menu,menuone,noselect" }

local kind_icons = {
  Text = "",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰇽",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
}

cmp.setup({
  preselect = cmp.PreselectMode.Item,
  mapping = {
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(_, vim_item)
      vim_item.kind = kind_icons[vim_item.kind]
      return vim_item
    end,
  },
  -- Note: The order matches the cmp menu's sort order.
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "buffer" },
    { name = "path" },
    { name = "orgmode" },
  }),
  experimental = {
    ghost_text = false,
  },
})

cmp.setup.filetype("gitcommit", {
  -- Note: The order matches the cmp menu's sort order.
  sources = cmp.config.sources({
    { name = "cmp_git" },
    { name = "buffer" },
  })
})
