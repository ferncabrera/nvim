local discipline = require("fern.discipline")

-- discipline.cowboy()

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>ww", ":w<CR>", { desc = "Save" })

-- Take lines and move them (VSCode opt/alt functionality)
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- For concating(???) strings to the same line but preserving mouse position
vim.keymap.set("n", "J", "mzJ`z")

-- For jumping up and down the page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

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
vim.keymap.set("n", "<leader>tx", "<cmd>!chmod +x %<CR>", { silent = true })

-- Just in case
vim.keymap.set("n", "Q", "<nop>")

-- Exit easy!!!!!
vim.keymap.set("i", "jj", "<Esc>", { noremap = false })
vim.keymap.set("i", "jk", "<Esc>", { noremap = false })

-- C root
vim.keymap.set("n", "<leader>tr", "<cmd>LazyRoot<CR>", { desc = "LazyRoot" })

-- Better resizing
vim.keymap.set("n", "<leader>w>", "<cmd>vertical resize +20<CR>", { desc = "Increase window width (20)" })
vim.keymap.set("n", "<leader>w<", "<cmd>vertical resize -20<CR>", { desc = "Decrease window width (20)" })

-- Better resizing (vert)
vim.keymap.set("n", "<leader>w+", "<cmd>resize +10<CR>", { desc = "Increase window height (10)" })
vim.keymap.set("n", "<leader>w-", "<cmd>resize -10<CR>", { desc = "Decrease window height (10)" })

vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
vim.keymap.set("n", "q", "<Nop>", { noremap = true, desc = "Disable q macro" })

function insertFullPath()
  local filepath = vim.fn.expand("%")
  vim.fn.setreg("+", filepath) -- write to clippoard
  return filepath
end

vim.keymap.set("n", "<leader>tf", function()
  local path = insertFullPath()
  if path then
    require("noice").notify("Copied full path: " .. path)
  else
    require("noice").notify("Failed to get full path", "error")
  end
end, { noremap = true, silent = true, desc = "Copy full path" })

vim.keymap.set("n", "<leader>tl", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  require("noice").notify("Copied relative path: " .. path)
end, { noremap = true, silent = true, desc = "Copy relative path" })

vim.keymap.set("n", "<leader>to", ":e <C-r>+<CR>", { noremap = true, desc = "Go to location in clipboard" })

-- quit + save CopilotChat history under cwd basename
vim.keymap.set("n", "<leader>qq", function()
  if package.loaded["CopilotChat"] then
    local session_name = vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))
    local ok, err = pcall(function()
      -- Save with a proper filename
      vim.cmd("CopilotChatSave " .. session_name)
    end)
    if not ok then
      vim.notify("Failed to save CopilotChat session: " .. tostring(err), vim.log.levels.WARN)
    end
  end
  vim.cmd("qa")
end, { desc = "Quit All & CopilotChatSave _project_name_" })

-- restore last auto-saved session
vim.keymap.set("n", "<leader>al", function()
  local session_name = vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.getcwd(), ":t"))

  if not package.loaded["CopilotChat"] then
    vim.cmd("CopilotChat")
    vim.cmd("CopilotChatLoad " .. session_name)
    return
  end

  local ok, chat = pcall(require, "CopilotChat")

  -- Plugin loaded. If window not visible, show it so user can inspect current history.
  if chat.chat and not chat.chat:visible() then
    chat.open()
    local choice = vim.fn.confirm(
      ("Restore CopilotChat session '%s'? This will replace current chat history."):format(session_name),
      "&Yes\n&No",
      2
    )
    if choice ~= 1 then
      return
    end
  end
  -- If window already visible, proceed without extra prompt (user can see it)
  chat.load(session_name)
end, { desc = "CopilotChatLoad _project_name_" })
