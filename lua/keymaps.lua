local utils_buffer = require("lib.utils_buffer")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set(
  "n",
  "tn",
  ":tabnew<cr>",
  { desc = "Tab new." }
)
vim.keymap.set(
  "n",
  "td",
  ":tabclose<cr>",
  { desc = "Tab close." }
)

vim.keymap.set(
  "n",
  "<leader>s",
  ":%s///gc<Left><Left><Left>",
  {
    noremap = true,
    desc = "Substitute last pattern."
  }
)
vim.keymap.set(
  "v",
  "<leader>s",
  "\"sy:%s/<C-r>s//<Left>",
  {
    noremap = true,
    desc = "Substitute pattern prepopulated with visual selection.",
  }
)

vim.keymap.set(
  "n",
  "<leader>S",
  ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
  {
    noremap = true,
    desc = "(Quickfix list) Substitute pattern.",
  }
)
vim.keymap.set(
  "v",
  "<leader>S",
  "\"sy:cdo s/<C-r>s//g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
  {
    noremap = true,
    desc = "(Quickfix list) Substitute pattern prepopulated with visual selection.",
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
  { "n", "v" },
  "Y",
  "\"+y",
  {
    noremap = true,
    silent = true,
    desc = "Yank text to clipboard."
  }
)
vim.keymap.set(
  "n",
  "yp",
  ":let @+ = expand(\"%\")<cr>",
  {
    noremap = true,
    desc = "Yank % to clipboard."
  }
)
vim.keymap.set(
  "n",
  "yo",
  ":%y+<cr>",
  {
    noremap = true,
    desc = "Yank buffer to clipboard.",
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

-- Emulates backtick dead-key for accents.
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
  { desc = "Move to prev word." }
)
vim.keymap.set(
  "c",
  "<M-f>",
  "<S-Right>",
  { desc = "Move to next word." }
)
vim.keymap.set(
  'c',
  '<M-BS>',
  '<C-w>',
  { desc = "Del prev word." }
)

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

vim.keymap.set("n", "-", vim.cmd.Ex)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set(
      { "n", "v" },
      "!",
      function()
        local paths = {}
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")

        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end

        for i = start_line, end_line do
          local line = vim.fn.getline(i)
          if line ~= "" and not line:match("^%.%.$") and not line:match("^%.$") then
            table.insert(paths, vim.fn.fnamemodify(line, ":p"))
          end
        end

        local path_string = table.concat(paths, " ")
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true) ..
          ":" ..
          path_string ..
          vim.api.nvim_replace_termcodes("<Home>", true, false, true) ..
          " " ..
          vim.api.nvim_replace_termcodes("<Left>", true, false, true) ..
          "!"
        )
      end,
      { desc = "Run cmd with file paths." }
    )
  end,
})

vim.keymap.set("n", "<C-f>", vim.lsp.buf.format)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol)
vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1, float = true }) end)
vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1, float = true }) end)

vim.keymap.set("", "<ScrollWheelUp>", "<C-Y>")
vim.keymap.set("", "<ScrollWheelDown>", "<C-E>")

vim.keymap.set(
  { "n", "v" },
  "<leader>gh",
  function()
    local function trim(s) return (s:gsub("%s+$", "")) end
    local function esc(s) return (s:gsub("([^%w])", "%%%1")) end

    local file = vim.fn.expand("%:p") -- absolute path
    local git_root = trim(vim.fn.system("git rev-parse --show-toplevel"))
    if git_root == "" then return end

    local remote = trim(vim.fn.system("git config --get remote.origin.url"))
    local commit = trim(vim.fn.system("git rev-parse HEAD"))
    local relative_file = file:gsub("^" .. esc(git_root .. "/"), "")

    local start_line = vim.fn.line(".")
    local end_line = vim.fn.line("v")
    if start_line > end_line then start_line, end_line = end_line, start_line end
    local line_range = (start_line == end_line)
        and ("L" .. start_line)
        or ("L" .. start_line .. "-L" .. end_line)

    local github_url = remote:gsub('git@github%.com:', 'https://github.com/'):gsub('%.git$', '')

    local url = string.format("%s/blob/%s/%s#%s", github_url, commit, relative_file, line_range)

    vim.fn.system('open "' .. url .. '"')
  end,
  { desc = "Open current line on github." }
)
