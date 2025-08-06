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
vim.g.lualine_show_last_modified = false
vim.g.lualine_show_count_info = false
vim.g.lualine_show_filetype_info = false

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

vim.keymap.set("n", "<leader>tg", function()
  vim.g.incline_show_git_diff = not vim.g.incline_show_git_diff
  require("lualine").refresh()
  notify_toggle("Incline Git Diff", vim.g.incline_show_git_diff)
end, { desc = "Toggle incline_show_git_diff", silent = true })

vim.keymap.set("n", "<leader>tm", function()
  vim.g.lualine_show_last_modified = not vim.g.lualine_show_last_modified
  require("lualine").refresh()
  notify_toggle("Lualine Last Modified", vim.g.lualine_show_last_modified)
end, { desc = "Toggle lualine_show_last_modified", silent = true })

vim.keymap.set("n", "<leader>tl", function()
  vim.g.lualine_show_count_info = not vim.g.lualine_show_count_info
  require("lualine").refresh()
  notify_toggle("Lualine Count Info", vim.g.lualine_show_count_info)
end, { desc = "Toggle lualine_show_count_info", silent = true })

vim.keymap.set("n", "<leader>tt", function()
  vim.g.lualine_show_filetype_info = not vim.g.lualine_show_filetype_info
  require("lualine").refresh()
  notify_toggle("Lualine Filetype Info", vim.g.lualine_show_filetype_info)
end, { desc = "Toggle lualine_show_filetype_info", silent = true })

vim.keymap.set("n", "<leader>ti", function()
  vim.g.incline_show_diagnostics = not vim.g.incline_show_diagnostics
  vim.cmd("redrawstatus!")
  notify_toggle("Incline Diagnostics", vim.g.incline_show_diagnostics)
end, { desc = "Toggle incline_show_diagnostics", silent = true })
