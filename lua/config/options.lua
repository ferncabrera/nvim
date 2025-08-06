-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- local opt = vim.opt
-- opt.tabstop = 4 -- A TAB character looks like 4 spaces
-- opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
-- opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
-- opt.shiftwidth = 4 -- Number of spaces inserted when indenting

vim.g.snacks_animate = false

vim.g.incline_show_git_diff = true
vim.g.incline_show_diagnostics = true

vim.api.nvim_set_keymap(
  "n",
  "<leader>tg",
  [[:lua vim.g.incline_show_git_diff = not vim.g.incline_show_git_diff; vim.cmd("redrawstatus!")<CR>]],
  { noremap = true, silent = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>ti",
  [[:lua vim.g.incline_show_diagnostics = not vim.g.incline_show_diagnostics; vim.cmd("redrawstatus!")<CR>]],
  { noremap = true, silent = true }
)
