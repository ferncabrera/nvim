-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- opt.tabstop = 4 -- A TAB character looks like 4 spaces
-- opt.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
-- opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
-- opt.shiftwidth = 4 -- Number of spaces inserted when indenting

-- Following main release....
vim.g.lazyvim_blink_main = true

vim.lsp.enable("postgres_lsp")

vim.opt.laststatus = 3
vim.opt.ls = 3
vim.opt.statusline = " %F  %=🌲 %{%v:lua.require'ecolog'.get_status()%} "
vim.opt.winborder = "single"

vim.opt.relativenumber = false
vim.opt.colorcolumn = "120"
