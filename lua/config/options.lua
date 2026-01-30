-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
-- vim.opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
-- vim.opt.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.smartindent = true -- Auto-indent new lines
vim.opt.breakindent = true -- Maintain indentation on wrapped lines

-- Following main release....
vim.g.lazyvim_blink_main = true
-- vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_picker = "snacks"

vim.lsp.enable("postgres_lsp")

function _G.Ecolog_statusline()
  local ok, ecolog = pcall(require, "ecolog")
  if not ok then
    return "noenv"
  end
  local ok_status, status = pcall(ecolog.get_status)
  if not ok_status or not status or status == "" then
    return "noenv"
  end
  return status
end

vim.opt.laststatus = 3
vim.opt.ls = 3
vim.opt.statusline = " %F  %= %{%v:lua.Ecolog_statusline()%} "
vim.opt.winborder = "single"

vim.opt.relativenumber = false
vim.opt.colorcolumn = "120"
