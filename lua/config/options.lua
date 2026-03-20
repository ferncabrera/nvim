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
vim.g.copilot_no_tab_map = true

vim.lsp.enable("postgres_lsp")

function _G.Statusline_path()
  local bt = vim.bo.buftype
  if bt ~= "" then
    -- Non-file buffer (plugin, terminal, help, etc.): show the buffer name
    local name = vim.fn.expand("%:t")
    return name ~= "" and name or vim.fn.expand("%")
  end

  local path = vim.fn.expand("%:p")
  if path == "" then
    return ""
  end

  return " " .. vim.fn.fnamemodify(path, ":h") .. "/"
end

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

-- Statusline highlight groups (uses kanagawa theme globals when available)
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local fg = vim.g.kanagawa_fg or "#c8c093"
    local fg_dim = "#a6a69c"
    vim.api.nvim_set_hl(0, "StatusLinePath", { fg = fg, bold = true })
    vim.api.nvim_set_hl(0, "StatusLineEnv", { fg = fg_dim, italic = true })
  end,
})

vim.opt.laststatus = 3
vim.opt.ls = 3
vim.opt.statusline =
  " %#StatusLinePath#%{%v:lua.Statusline_path()%}%#StatusLine#  %= %#StatusLineEnv#%{%v:lua.Ecolog_statusline()%} "
vim.opt.winborder = "single"

vim.opt.relativenumber = false
vim.opt.colorcolumn = "120"
