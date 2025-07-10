local utils_buffer = require("lib.utils_buffer")

vim.keymap.set(
  "",
  "<ScrollWheelUp>",
  "<C-Y>",
  {
    silent = true,
    desc = "Smooth mouse wheel scroll."
  }
)
vim.keymap.set(
  "",
  "<ScrollWheelDown>",
  "<C-E>",
  {
    silent = true,
    desc = "Smooth mouse wheel scroll."
  }
)

-- Tabs mappings
vim.keymap.set(
  "n",
  "tn",
  ":tabnew<cr>",
  {
    silent = true,
    desc = "Tab new."
  }
)

vim.keymap.set(
  "n",
  "td",
  ":tabclose<cr>",
  {
    silent = true,
    desc = "Tab close."
  }
)

vim.keymap.set(
    "n",
    "<leader>pm",
    function()
      local function save_clipboard_image()
        local temp_path = "/tmp/img.png"
        local result = os.execute("pngpaste " .. temp_path .. " > /dev/null 2>&1")
        if result ~= 0 then return nil end
        return temp_path
        end

      local clip_path = save_clipboard_image()
      if not clip_path or vim.fn.filereadable(clip_path) ~= 1 then
          vim.notify("❌ No image in clipboard (pngpaste failed)", vim.log.levels.ERROR)
        if clip_path then
            vim.fn.delete(clip_path, "rf")
        end
        return
        end

      local buf_path = vim.fn.expand("%:p")
      local base_dir = vim.fn.fnamemodify(buf_path, ":h")
      local media_dir = base_dir .. "/media"
      vim.fn.mkdir(media_dir, "p")

      local filename = os.date("clip-%Y%m%d-%H%M%S") .. ".png"
      local target_path = media_dir .. "/" .. filename
      vim.fn.rename(clip_path, target_path)

      vim.api.nvim_put({ "media/" .. filename }, "c", true, true)
      vim.notify("✅ Pasted: " .. "media/" .. filename, vim.log.levels.INFO)
    end
)

vim.keymap.set(
  "n",
  "<C-s>",
  "\"_diwP",
  {
    noremap = true,
    silent = true,
    desc = "Stamp (Del & replace with yanked text)"
  }
)

vim.keymap.set(
  "t",
  "<C-o>",
  "<C-\\><C-n>",
  {
    noremap = true,
    silent = true,
    desc = "Exit terminal mode"
  }
)

vim.keymap.set(
  { "n", "v" },
  "Y",
  "\"+y",
  {
    noremap = true,
    silent = true,
    desc = "Yanked text to-clipboard shortcut"
  }
)

vim.keymap.set(
  "n",
  "yp",
  ":let @+ = expand(\"%\")<cr>",
  {
    noremap = true,
    desc = "Yank % to clipboard"
  }
)

local VOCALS_ACCENTS = {
  a = "à",
  A = "À",
  e = "è",
  E = "È",
  i = "ì",
  I = "Ì",
  o = "ò",
  O = "Ò",
  u = "ù",
  U = "Ù",
}

-- Emulate backtick dead-key for accents
for key, value in pairs(VOCALS_ACCENTS) do
  vim.keymap.set(
    "i",
    "<A-`>" .. key,
    value,
    { noremap = true, silent = true, desc = "Type accent " .. value .. " char" }
  )
end

vim.keymap.set(
  "n",
  "<leader>bo",
  ":%bd|e#<cr>",
  {
    noremap = true,
    silent = true,
    desc = "Delete other buffers."
  }
)
vim.keymap.set(
  "n",
  "<leader>bd",
  function()
    if utils_buffer.delete_buffer(0, { force = true, unload = true }, false) then
      print("Current buffer deleted")
    else
      print("⚠️ : Current buffer is in modified state")
    end
  end,
  {
    noremap = true,
    silent = true,
    desc = "Delete current buffer."
  }
)
vim.keymap.set(
  "n",
  "<leader>bD",
  function()
    if utils_buffer.delete_buffer(0, { force = true, unload = true }, true) then
      print("Current buffer deleted")
    else
      print("⚠️ : Something went wrong - cannot force delete the buffer")
    end
  end,
  {
    noremap = true,
    silent = true,
    desc = "Force delete current buffer."
  }
)

-- Search for visually selected text using '*' and '#'
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text#Simple
vim.cmd([[
  vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gVzv:call setreg('"', old_reg, old_regtype)<CR>
  vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gVzv:call setreg('"', old_reg, old_regtype)<CR>
]])

vim.keymap.set(
  "c",
  "<C-A>",
  "<Home>",
  { desc = "Move to start of line." }
)
vim.keymap.set(
  "c",
  "<M-b>",
  "<S-Left>",
  { desc = "Move to prev word" }
)
vim.keymap.set(
  "c",
  "<M-f>",
  "<S-Right>",
  { desc = "Move to next word" }
)

vim.keymap.set(
  "n",
  "yo",
  function()
    vim.cmd("%y+")
  end,
  {
    noremap = true,
    silent = true,
    desc = "Copy buffer to clipboard.",
  }
)

-- Prepare to print lua code
vim.keymap.set(
  "n",
  "<leader>l",
  ":lua vim.print()<left>",
  {
    noremap = true,
    silent = false,
    desc = "Log with lua."
  }
)

vim.keymap.set("n", "<C-f>", vim.lsp.buf.format)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol)
vim.keymap.set("n", "]g", function() vim.diagnostic.jump({count=1, float=true}) end)
vim.keymap.set("n", "[g", function() vim.diagnostic.jump({count=-1, float=true}) end)
