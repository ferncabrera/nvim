-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Set highlight for matching brackets/parentheses/quotes
vim.api.nvim_set_hl(0, "MatchParen", { fg = "#EEF5FF", bg = "#D27E99", bold = true })

vim.opt.relativenumber = false

vim.opt.colorcolumn = "120"

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:[vV]", -- matches entering visual modes: char, line, block
  callback = function()
    require("incline").refresh()
  end,
})
-- vim.cmd("highlight ColorColumn ctermbg=0 guibg=#c8c093")

vim.api.nvim_set_hl(0, "CopilotChatHeader", { fg = "#b35b79", bold = true })
vim.api.nvim_set_hl(0, "CopilotChatSeparator", { fg = "#5e857a" })
