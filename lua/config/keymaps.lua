local discipline = require("fern.discipline")

-- discipline.cowboy()

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Comment toggle with <C-/> (and <C-_>, which is what many terminal emulators
-- actually send for Ctrl+/). This overrides the LazyVim default that opens a
-- terminal on <C-/>. gcc/gc come from the mini.comment extra.
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("x", "<C-/>", "gc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("x", "<C-_>", "gc", { remap = true, silent = true, desc = "Toggle comment" })

vim.keymap.set("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save" })

-- Take lines and move them (VSCode opt/alt functionality)
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines but keep the cursor where it was
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- For jumping up and down the page
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- For diffing all open windows
vim.keymap.set("n", "<leader>td", function()
  local diff = vim.wo.diff
  if diff then
    vim.cmd("diffoff!")
  else
    vim.cmd("windo diffthis")
  end
end, { desc = "Toggle diff for all windows" })

-- greatest remap ever
-- vim.keymap.set("x", "<leader>pp", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({ "n", "v" }, "<leader>ty", [["+y]], { desc = "greatest remap ever" })
-- vim.keymap.set("n", "<leader>tY", [["+Y]], { desc = "greatest remap ever (line-mode)" })

-- Delete to void register
-- vim.keymap.set({ "n", "v" }, "<leader>pd", '"_d', { desc = "primeage void register delete" })

-- Sweet regex string replacement and easily create executable file!!!
vim.keymap.set(
  "n",
  "<leader>ts",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "primeagen string swap" }
)
vim.keymap.set(
  "n",
  "<leader>tS",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gcI<Left><Left><Left><Left>]],
  { desc = "primeagen string swap (prompt)" }
)
vim.keymap.set("n", "<leader>tx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable (chmod +x)" })

-- Exit easy!!!!!
vim.keymap.set("i", "jj", "<Esc>", { noremap = false })
vim.keymap.set("i", "jk", "<Esc>", { noremap = false })

-- C root
vim.keymap.set("n", "<leader>t.", "<cmd>LazyRoot<CR>", { desc = "LazyRoot" })

-- Better resizing
vim.keymap.set("n", "<leader>w>", "<cmd>vertical resize +20<CR>", { desc = "Increase window width (20)" })
vim.keymap.set("n", "<leader>w<", "<cmd>vertical resize -20<CR>", { desc = "Decrease window width (20)" })

-- Better resizing (vert)
vim.keymap.set("n", "<leader>w+", "<cmd>resize +10<CR>", { desc = "Increase window height (10)" })
vim.keymap.set("n", "<leader>w-", "<cmd>resize -10<CR>", { desc = "Decrease window height (10)" })

vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
vim.keymap.set("n", "q", "<Nop>", { noremap = true, desc = "Disable q macro" })

-- Copy the file name / full path / cwd-relative path of the current buffer to the clipboard.
-- (<leader>tf used expand("%"), which is only a full path when the file was opened by an absolute name.)
local function yank_path(mod, label)
  return function()
    local p = vim.fn.expand("%" .. mod)
    if p == "" then
      return vim.notify("No file in buffer", vim.log.levels.WARN)
    end
    vim.fn.setreg("+", p)
    vim.notify("Copied " .. label .. ": " .. p)
  end
end
vim.keymap.set("n", "<leader>tc", yank_path(":t", "file name"), { desc = "Copy file name" })
vim.keymap.set("n", "<leader>tf", yank_path(":p", "full path"), { desc = "Copy full path" })
vim.keymap.set("n", "<leader>tp", yank_path(":.", "relative path"), { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>to", ":e <C-r>+<CR>", { noremap = true, desc = "Go to location in clipboard" })

-- <leader>qq: LazyVim's default Quit All (the CopilotChat save branch here could never run: copilotchat.lua returns {})

-- restore last auto-saved session
-- vim.keymap.set("n", "<leader>al", function()
--   local session_name = vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
--
--   if not package.loaded["CopilotChat"] then
--     vim.cmd("CopilotChat")
--     vim.cmd("CopilotChatLoad " .. session_name)
--     return
--   end
--
--   local ok, chat = pcall(require, "CopilotChat")
--
--   -- Plugin loaded. If window not visible, show it so user can inspect current history.
--   if chat.chat and not chat.chat:visible() then
--     chat.open()
--     local choice = vim.fn.confirm(
--       ("Restore CopilotChat session '%s'? This will replace current chat history."):format(session_name),
--       "&Yes\n&No",
--       2
--     )
--     if choice ~= 1 then
--       return
--     end
--   end
--   -- If window already visible, proceed without extra prompt (user can see it)
--   chat.load(session_name)
-- end, { desc = "CopilotChatLoad _project_name_" })

-- Toggle vim-dadbod's default connection (:DB + completion) from the project env instead of a
-- hardcoded URL. Reads ecolog's DATABASE_URL, then $DBUI_URL / $DATABASE_URL.
vim.keymap.set("n", "<leader>tD", function()
  if vim.g.db then
    vim.g.db = nil
    return vim.notify("DB connection unset", vim.log.levels.INFO)
  end
  local vars = require("ecolog").get_env_vars()
  local url = (vars.DATABASE_URL and vars.DATABASE_URL.raw_value) or vim.env.DBUI_URL or vim.env.DATABASE_URL
  if not url then
    return vim.notify("No DATABASE_URL / DBUI_URL in env", vim.log.levels.WARN)
  end
  vim.g.db = url
  vim.notify("DB connection set from env (" .. url:gsub("//.-@", "//***@") .. ")", vim.log.levels.INFO)
end, { desc = "Toggle DB connection (from env)" })

vim.g.snacks_animate = false

vim.g.incline_show_git_diff = true
vim.g.incline_show_diagnostics = true
vim.g.incline_show_navic = false
-- vim.g.lualine_show_last_modified = false
-- vim.g.lualine_show_count_info = false
-- vim.g.lualine_show_filetype_info = false

local noice = require("noice")

local function notify_toggle(name, state)
  if state then
    -- Show warning message with ON color
    noice.notify(name .. ": ON", "info")
  else
    -- Show warning message with OFF color (you can customize the message)
    noice.notify(name .. ": OFF", "warn")
  end
end

-- vim.keymap.set("n", "<leader>ta", function()
--   local any_enabled = vim.g.lualine_show_last_modified
--     or vim.g.lualine_show_count_info
--     or vim.g.lualine_show_filetype_info
--
--   local new_state = not any_enabled
--
--   vim.g.lualine_show_last_modified = new_state
--   vim.g.lualine_show_count_info = new_state
--   vim.g.lualine_show_filetype_info = new_state
--
--   require("lualine").refresh()
--
--   local msg = "Lualine All Info: " .. (new_state and "ON" or "OFF")
--   noice.notify(msg, new_state and "info" or "warn")
-- end, { desc = "Toggle all Lualine Info", silent = true })

-- vim.keymap.set("n", "<leader>tm", function()
--   vim.g.lualine_show_last_modified = not vim.g.lualine_show_last_modified
--   require("lualine").refresh()
--   notify_toggle("Lualine Last Modified", vim.g.lualine_show_last_modified)
-- end, { desc = "Toggle lualine_show_last_modified", silent = true })

-- vim.keymap.set("n", "<leader>tl", function()
--   vim.g.lualine_show_count_info = not vim.g.lualine_show_count_info
--   require("lualine").refresh()
--   notify_toggle("Lualine Count Info", vim.g.lualine_show_count_info)
-- end, { desc = "Toggle lualine_show_count_info", silent = true })

-- vim.keymap.set("n", "<leader>tt", function()
--   vim.g.lualine_show_filetype_info = not vim.g.lualine_show_filetype_info
--   require("lualine").refresh()
--   notify_toggle("Lualine Filetype Info", vim.g.lualine_show_filetype_info)
-- end, { desc = "Toggle lualine_show_filetype_info", silent = true })

vim.keymap.set("n", "<leader>tg", function()
  vim.g.incline_show_git_diff = not vim.g.incline_show_git_diff
  -- require("lualine").refresh()
  notify_toggle("Incline Git Diff", vim.g.incline_show_git_diff)
end, { desc = "Toggle incline_show_git_diff", silent = true })

vim.keymap.set("n", "<leader>ti", function()
  vim.g.incline_show_diagnostics = not vim.g.incline_show_diagnostics
  vim.cmd("redrawstatus!")
  notify_toggle("Incline Diagnostics", vim.g.incline_show_diagnostics)
end, { desc = "Toggle incline_show_diagnostics", silent = true })

vim.keymap.set("n", "<leader>tm", function()
  vim.g.incline_show_navic = not vim.g.incline_show_navic
  vim.cmd("redrawstatus!")
  notify_toggle("Incline Navic", vim.g.incline_show_navic)
end, { desc = "Toggle incline_show_navic", silent = true })

-- Toggle the (custom) statusline. Relocated here from the disabled lualine spec
-- so it no longer relies on a side effect inside a plugin table.
vim.keymap.set("n", "<leader>tt", function()
  if vim.o.laststatus == 0 then
    vim.o.laststatus = 3
  else
    vim.o.laststatus = 0
  end
end, { desc = "Toggle Statusline" })

-- vim.keymap.set("n", "<C-c>", "<cmd>qa<CR>", { desc = "Quit All" })

-- Semantic tokens per buffer/client (vtsls/gopls/rust-analyzer compute + decode them after every edit;
-- treesitter already provides nearly everything kanagawa uses). Toggle to measure on big TS files.
Snacks.toggle({
  name = "Semantic Tokens",
  get = function()
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0, method = "textDocument/semanticTokens/full" })) do
      if vim.lsp.semantic_tokens.is_enabled({ bufnr = 0, client_id = c.id }) then
        return true
      end
    end
    return false
  end,
  set = function(state)
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0, method = "textDocument/semanticTokens/full" })) do
      vim.lsp.semantic_tokens.enable(state, { bufnr = 0, client_id = c.id })
    end
  end,
}):map("<leader>uH")
