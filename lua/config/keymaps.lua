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

-- greatest remap ever
-- vim.keymap.set("x", "<leader>pp", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>ty", [["+y]], { desc = "greatest remap ever" })
vim.keymap.set("n", "<leader>tY", [["+Y]], { desc = "greatest remap ever (line-mode)" })

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
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- Just in case
vim.keymap.set("n", "Q", "<nop>")

-- Exit easy!!!!!
vim.keymap.set("i", "jj", "<Esc>", { noremap = false })
vim.keymap.set("i", "jk", "<Esc>", { noremap = false })

-- C root
vim.keymap.set("n", "<leader>tr", "<cmd>LazyRoot<CR>", { desc = "LazyRoot" })
