-- Keep the last line of a file at the bottom of the window.
--
-- Neovim lets the view scroll past the end of the buffer (<C-e>, <C-f>, zz on the last line, the
-- <C-d>zz / <C-u>zz mappings, mouse wheel), leaving `~` filler rows below the true EOF. There is no
-- option to forbid it, so this clamps the view after every scroll/resize: whenever the last line is
-- visible with filler below it, the top line is moved down until the file fills the window (or the
-- file starts at line 1). Wrapped lines, folds and virtual lines are accounted for via
-- nvim_win_text_height(). Toggle with <leader>uo.
local M = {}

local GROUP = "fern_scroll_eof"
M.enabled = false

local function skip(win)
  if vim.api.nvim_win_get_config(win).relative ~= "" or vim.wo[win].diff then
    return true
  end
  local bt = vim.bo[vim.api.nvim_win_get_buf(win)].buftype
  return bt == "nofile" or bt == "prompt" or bt == "terminal" or bt == "quickfix"
end

--- Pull the view down so no filler rows show below the last line.
---@param win integer
function M.clamp(win)
  win = (win == nil or win == 0) and vim.api.nvim_get_current_win() or win
  if not vim.api.nvim_win_is_valid(win) or skip(win) then
    return
  end
  vim.api.nvim_win_call(win, function()
    local last = vim.api.nvim_buf_line_count(0)
    if vim.fn.line("w$") < last then
      return -- the last line is not on screen, so there is no filler
    end
    local view = vim.fn.winsaveview()
    if view.topline <= 1 then
      return -- the whole file already starts at the top
    end
    local height = vim.api.nvim_win_get_height(0)
    local rows = vim.api.nvim_win_text_height(0, { start_row = view.topline - 1, end_row = last - 1 }).all
    if rows >= height then
      return
    end
    -- walk topline up (towards line 1) until the text from there to EOF fills the window
    local topline = view.topline
    while topline > 1 and rows < height do
      topline = topline - 1
      rows = vim.api.nvim_win_text_height(0, { start_row = topline - 1, end_row = last - 1 }).all
    end
    view.topline = topline
    vim.fn.winrestview(view)
  end)
end

function M.enable()
  M.enabled = true
  local group = vim.api.nvim_create_augroup(GROUP, { clear = true })
  vim.api.nvim_create_autocmd("WinScrolled", {
    group = group,
    callback = function()
      -- v:event lists every window that scrolled/resized in this event
      local any = false
      for key in pairs(vim.v.event) do
        local win = tonumber(key)
        if win then
          any = true
          M.clamp(win)
        end
      end
      if not any then
        M.clamp(0)
      end
    end,
  })
  -- height changes (closing a split, resizing the terminal) and edits at EOF also create filler
  vim.api.nvim_create_autocmd({ "WinResized", "VimResized", "BufWinEnter", "TextChanged" }, {
    group = group,
    callback = function()
      M.clamp(0)
    end,
  })
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    M.clamp(win)
  end
end

function M.disable()
  M.enabled = false
  pcall(vim.api.nvim_del_augroup_by_name, GROUP)
end

function M.toggle()
  if M.enabled then
    M.disable()
  else
    M.enable()
  end
end

return M
