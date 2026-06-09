-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Set highlight for matching brackets/parentheses/quotes

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*:[vV]", -- matches entering visual modes: char, line, block
  callback = function()
    require("incline").refresh()
  end,
})
-- vim.cmd("highlight ColorColumn ctermbg=0 guibg=#c8c093")

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

local augroup = vim.api.nvim_create_augroup("GitUIInclineRefresh", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = "*",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name:match("gitui") then
      require("incline").disable()
    end
  end,
})

-- Re-enable Incline after GitUI closes
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  pattern = "*",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name:match("gitui") then
      require("incline").enable()
      require("incline").refresh()
    end
  end,
})

-- local yazi_group = vim.api.nvim_create_augroup("YaziInclineRefresh", { clear = true })
--
-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = yazi_group,
--   pattern = "*",
--   callback = function(args)
--     local name = vim.api.nvim_buf_get_name(args.buf)
--     if name:match("yazi") then
--       local pickers = require("snacks.picker.core.picker").get()
--       if #pickers > 0 then
--         pickers[#pickers]:close()
--       end
--       require("incline").disable()
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("TermClose", {
--   group = yazi_group,
--   pattern = "*",
--   callback = function(args)
--     local name = vim.api.nvim_buf_get_name(args.buf)
--     if name:match("yazi") then
--       require("incline").enable()
--       require("incline").refresh()
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbui",
  callback = function(ev)
    vim.keymap.del("n", "H", { buffer = ev.buf })
  end,
})

-- StatusLine highlight for LazyVim (without lualine)
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("CustomStatuslineColors", { clear = true }),
  callback = function()
    if vim.opt.termguicolors:get() then
      if MODE == "dark" then
        if THEME == "wave" then
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "#1e1f28", fg = "#DCD7BA", bold = false })
        else
          vim.api.nvim_set_hl(0, "StatusLine", { bg = "#393836", fg = "#f2ecbc", bold = false })
        end
      else
        vim.api.nvim_set_hl(0, "StatusLine", { bg = "#f2ecbc", fg = "#727169", bold = false })
      end
    else
      vim.api.nvim_set_hl(0, "StatusLine", { ctermbg = 235, ctermfg = 252, bold = false })
    end
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "MatchParen", { fg = "#EEF5FF", bg = "#D27E99", bold = true })
    vim.api.nvim_set_hl(0, "CopilotChatHeader", { fg = "#b35b79", bold = true })
    vim.api.nvim_set_hl(0, "CopilotChatSeparator", { fg = "#5e857a" })
  end,
})

if MODE == "dark" then
  if THEME == "wave" then
    vim.cmd([[
      autocmd RecordingEnter * lua vim.api.nvim_set_hl(0, "StatusLine", { bg = "#dca561", fg = "#727169", bold = false })
      autocmd RecordingLeave * lua vim.api.nvim_set_hl(0, "StatusLine", { bg = "#1e1f28", fg = "#DCD7BA", bold = false })
    ]])
  else
    vim.cmd([[
      autocmd RecordingEnter * lua vim.api.nvim_set_hl(0, "StatusLine", { bg = "#c4b28a", fg = "#1e1f28", bold = false })
      autocmd RecordingLeave * lua vim.api.nvim_set_hl(0, "StatusLine", { bg = "#393836", fg = "#f2ecbc", bold = false })
    ]])
  end
else
  vim.cmd([[
    autocmd RecordingEnter * lua vim.api.nvim_set_hl(0, "StatusLine", { bg = "#5a7785", fg = "#f2ecbc", bold = false })
    autocmd RecordingLeave * lua vim.api.nvim_set_hl(0, "StatusLine", { bg = "#f2ecbc", fg = "#727169", bold = false })
  ]])
end

local ns = vim.api.nvim_create_namespace("oil_highlight_entry")
vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = function(args)
    local bufnr = args.data.buf
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      local winid = vim.fn.bufwinid(bufnr)
      if winid == -1 then
        return
      end

      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

      local ok, oil = pcall(require, "oil")
      if not ok then
        return
      end

      local entry
      vim.api.nvim_win_call(winid, function()
        entry = oil.get_cursor_entry()
      end)
      if not entry then
        return
      end

      local lnum = vim.api.nvim_win_get_cursor(winid)[1] - 1
      local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]
      if not line then
        return
      end

      local col = string.find(line, entry.name, 1, true)
      if col then
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, col - 1, {
          end_col = col - 1 + #entry.name,
          hl_group = "Visual",
        })
        vim.defer_fn(function()
          pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns, 0, -1)
        end, 1500)
      end
    end)
  end,
})

-- Apply immediately on startup (in case colorscheme loads before this)
vim.cmd("doautocmd ColorScheme")
