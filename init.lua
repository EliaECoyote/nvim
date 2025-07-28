-- Save undo history to a file stored in `:h undodir`
vim.o.undofile = true

-- Refresh file every time you access the buffer.
-- This is useful to sync buffer when it has changed on disk.
vim.cmd [[
  au FocusGained,BufEnter * :checktime
]]

-- Enable mouse visual selection
vim.o.mouse = "a"

-- Enables Vim per-project configuration files
vim.o.exrc = true
vim.o.secure = true

vim.filetype.add({
  -- Sets filetypes based on file extension.
  extension = { mdx = "mdx" }
})

-- Autocomplete
vim.o.completeopt = "menu,menuone,noinsert,popup,fuzzy"
vim.o.cia = "kind,abbr,menu"

local kind_icons = {
  Text = "",
  Method = "󰊕",
  Function = "󰊕",
  Constructor = "",
  Field = "󰂡",
  Variable = "󰂡",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "",
  Value = "󰎠",
  Enum = "󰂡",
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

local group_cmp = vim.api.nvim_create_augroup("my_completion", { clear = true })
local timer = vim.uv.new_timer()

vim.api.nvim_create_autocmd("LspAttach", {
  group = group_cmp,
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client ~= nil and client:supports_method('textDocument/completion') then
      -- trigger autocompletion on EVERY keypress.
      local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, bufnr, {
        autotrigger = false,
        convert = function(item)
          local kind = vim.lsp.protocol.CompletionItemKind[item.kind]
          -- Extract import path and additional info from labelDetails
          local menu_info = ""
          if item.labelDetails then
            local detail = item.labelDetails.detail or ""
            local description = item.labelDetails.description or ""
            local parts = {}
            if detail ~= "" then table.insert(parts, detail) end
            if description ~= "" then table.insert(parts, description) end
            menu_info = table.concat(parts, " ")
          end

          -- Truncate long text to control width
          local abbr = item.label:gsub("%b()", "")
          if #abbr > 25 then
            abbr = abbr:sub(1, 24) .. "…"
          end

          if #menu_info > 10 then
            menu_info = menu_info:sub(1, 9) .. "…"
          end

          return {
            abbr = abbr,
            kind = kind,
            menu = menu_info,
            filterText = item.filterText,
            sortText = item.sortText,
            icase = 1,
            dup = 1,
            empty = 1
          }
        end,
      })
    end

    local function trigger_completion()
      if vim.fn.mode() == 'i' and vim.api.nvim_get_current_buf() == bufnr then
        vim.lsp.completion.get()
      end
    end

    vim.api.nvim_create_autocmd("InsertCharPre", {
      buffer = bufnr,
      callback = function()
        timer:stop()
        timer:start(100, 0, vim.schedule_wrap(trigger_completion))
      end,
    })

    vim.keymap.set("i", "<Tab>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
  end,
})

vim.api.nvim_create_autocmd("CompleteChanged", {
  group = group_cmp,
  callback = function()
    local info = vim.fn.complete_info({ "selected" })
    if info.preview_bufnr and vim.bo[info.preview_bufnr].filetype == "" then
      vim.bo[info.preview_bufnr].filetype = "markdown"
      vim.wo[info.preview_winid].conceallevel = 2
      vim.wo[info.preview_winid].concealcursor = "niv"
    end
  end,
  desc = "Auto set md filetype for preview"
})

vim.api.nvim_create_autocmd("CompleteDone", {
  group = group_cmp,
  callback = function(ev)
    local item =
        vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
    if not item then
      return
    end

    if item.kind == 3
        and item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet
        and (item.textEdit ~= nil or item.insertText ~= nil)
    then
      vim.schedule(function()
        if vim.api.nvim_get_mode().mode == "s" then
          vim.lsp.buf.signature_help()
        end
      end)
    end
  end,
  desc = "Auto show signature help on completion done",
})


require("config_keymaps")
require("config_theme")
require("config_search_and_replace")

-- See https://github.com/neovim/nvim-lspconfig/tree/master/lsp for configurations
local constants_lsp = require("lib.constants_lsp")
for _, lsp in ipairs(constants_lsp.LSP_SERVERS) do
  vim.lsp.enable(lsp)
end

require("plugins")
