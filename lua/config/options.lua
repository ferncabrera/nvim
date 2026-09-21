-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- vim.opt.tabstop = 4 -- A TAB character looks like 4 spaces
-- vim.opt.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
-- vim.opt.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.breakindent = true -- Maintain indentation on wrapped lines

-- vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_picker = "snacks"
-- imports LazyVim's neo-tree extra and skips the snacks explorer (and its <leader>e/E/fe/fE keys),
-- instead of disabling the auto-imported extra and hand-copying the neo-tree spec
vim.g.lazyvim_explorer = "neo-tree"

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

  return " " .. vim.fn.fnamemodify(path, ":h") .. "/"
end

-- Macro recording indicator. 0.12 redraws the statusline when recording starts/stops, so no autocmd is
-- needed; the previous RecordingEnter handlers recoloured `StatusLine`, which this statusline never paints.
function _G.Statusline_rec()
  local r = vim.fn.reg_recording()
  return r ~= "" and ("%#StatusLineRec# 󰑊 @" .. r .. " %#StatusLineBG#") or ""
end

-- ecolog's statusline integration (E/S icons, shelter state, var count, configured in ecolog.lua);
-- `ecolog.get_status()` only returned the env file basename.
function _G.Ecolog_statusline()
  local ok, sl = pcall(require, "ecolog.integrations.statusline")
  if not ok then
    return ""
  end
  local s = sl.get_statusline() -- already contains %#hl# markup and %* resets, cached 1 s
  return s ~= "" and s or "%#StatusLineEnv#noenv"
end

-- Statusline highlight groups live in the ColorScheme handler in lua/config/autocmds.lua
vim.opt.statusline =
  "%#StatusLineBG# %#StatusLinePath#%{%v:lua.Statusline_path()%}%#StatusLineBG#%{%v:lua.Statusline_rec()%}%= %#StatusLineEnv#%{%v:lua.Ecolog_statusline()%} "
vim.opt.winborder = "single"
vim.opt.wildoptions:append("fuzzy") -- fuzzy :b / :h / :set / user-command candidates in the cmdline menu

vim.opt.relativenumber = false
vim.opt.colorcolumn = "120"
