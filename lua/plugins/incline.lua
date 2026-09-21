-- Per-window floating "statusline" (top-right): diagnostics, git diff, breadcrumbs, filename, search count.
-- Rendered on every CursorMoved(I) for every window, so everything below is computed at most once per render.

-- kanagawa variant -> pill colours. `vim.g.kanagawa_variant` is set by the ColorScheme handler in
-- lua/config/autocmds.lua ("wave" | "dragon" | "lotus"), so light/dark switches follow 'background'.
local variant_colors = {
  wave = { fg = "#dcd7ba", focused = "#e46876", unfocused = "#2a2a37" },
  dragon = { fg = "#f2ecbc", focused = "#c4746e", unfocused = "#393836" },
  lotus = { fg = "#f2ecbc", focused = "#b35b79", unfocused = "#938056" },
}

local function get_colors(props)
  local v = variant_colors[vim.g.kanagawa_variant] or variant_colors.dragon
  return { fg = v.fg, bg = props.focused and v.focused or v.unfocused }
end

-- highlight lookups are cached per colorscheme instead of 3 nvim_get_hl calls per breadcrumb per render
local hl_cache = {}
local function hl_attr(group, attr)
  local key = group .. "." .. attr
  if hl_cache[key] == nil then
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    hl_cache[key] = (ok and hl and hl[attr]) and string.format("#%06x", hl[attr]) or false
  end
  return hl_cache[key] or nil
end
vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("incline_hl_cache", { clear = true }),
  callback = function()
    hl_cache = {}
  end,
})

local sev = vim.diagnostic.severity
local diag_icons = {
  { sev.ERROR, "", "DiagnosticSignError" },
  { sev.WARN, "", "DiagnosticSignWarn" },
  { sev.INFO, "", "DiagnosticSignInfo" },
  { sev.HINT, "", "DiagnosticSignHint" },
}
local function diag_label(buf)
  local counts, out = vim.diagnostic.count(buf), {} -- one call instead of four list copies
  for _, d in ipairs(diag_icons) do
    if counts[d[1]] then
      out[#out + 1] = { d[2] .. counts[d[1]] .. " ", group = d[3] }
    end
  end
  if #out > 0 then
    out[#out + 1] = { "" }
    return { " ", out }
  end
  return out
end

local git_icons = { removed = "", changed = "", added = "" }
local function git_diff(buf)
  local signs = vim.b[buf].gitsigns_status_dict
  local labels = {}
  if signs == nil then
    return labels
  end
  for name, icon in pairs(git_icons) do
    if tonumber(signs[name]) and signs[name] > 0 then
      table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
    end
  end
  if #labels > 0 then
    table.insert(labels, { "" })
  end
  return labels
end

return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  config = function()
    local navic = require("nvim-navic")
    local devicons = require("nvim-web-devicons")

    require("incline").setup({
      ignore = {
        floating_wins = false,
        wintypes = function(winid, wintype)
          local zen = package.loaded["snacks"].zen
          if zen.win and not zen.win.closed then
            return winid ~= zen.win.win
          end
          return wintype ~= ""
        end,
        buftypes = {
          "nofile",
          "quickfix",
          "help",
          "terminal",
          "prompt",
        },
      },
      window = {
        padding = 0,
        width = "fit",
        margin = { horizontal = 0, vertical = 0 },
        placement = {
          horizontal = "right", -- 'left', 'right', or 'center'
          vertical = "top", -- 'top' or 'bottom'
        },
      },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local modified_icon = vim.bo[props.buf].modified and "⚪ " or ""

        local icon
        if vim.bo[props.buf].filetype == "oil" then
          filename = "Oil:///"
          icon = "󰙅"
        else
          icon = (devicons.get_icon_color(filename))
          if not icon or icon == "" then
            icon = "󰈔"
          end
        end

        local colors = get_colors(props)

        -- compute each section once and reuse it
        local diag = (vim.g.incline_show_diagnostics and props.focused) and diag_label(props.buf) or {}
        local gd = (vim.g.incline_show_git_diff and props.focused) and git_diff(props.buf) or {}
        local has_diag, has_git = #diag > 0, #gd > 0

        local git_diff_section = has_git and { has_diag and "" or " ", gd } or {}

        -- Navic breadcrumbs: only computed while shown (<leader>tm)
        local breadcrumbs_section = {}
        if vim.g.incline_show_navic and props.focused and navic.is_available(props.buf) then
          local breadcrumbs = {}
          for _, item in ipairs(navic.get_data(props.buf) or {}) do
            table.insert(breadcrumbs, {
              { " ", guifg = hl_attr("NavicSeparator", "fg") },
              { item.icon, guifg = hl_attr("NavicIcons" .. item.type, "fg") },
              { item.name, guifg = hl_attr("NavicText", "fg") },
            })
          end
          if #breadcrumbs > 0 then
            local show_space = not (has_diag or has_git)
            breadcrumbs_section = show_space and { breadcrumbs, { " " } } or { breadcrumbs }
          end
        end

        -- Search count: check hlsearch first (searchcount used to run on every render even with it off),
        -- and keep Neovim's own limits ('maxsearchcount', 20 ms timeout) so big buffers do not stall.
        local search_section, search_active = {}, false
        if props.focused and vim.v.hlsearch == 1 then
          local ok, count = pcall(vim.fn.searchcount, { recompute = 1, maxcount = vim.o.maxsearchcount, timeout = 20 })
          if ok and count.total and count.total > 0 then
            local total = count.total > vim.o.maxsearchcount and (">" .. vim.o.maxsearchcount) or tostring(count.total)
            search_active = true
            search_section = {
              { " 󱎸", group = "IncSearch" },
              { (" \\<%s>\\"):format(vim.fn.getreg("/")), group = "IncSearch" },
              { (" [%d/%s] "):format(count.current, total), group = "IncSearch" },
              { modified_icon, group = "IncSearch" },
            }
          end
        end

        return {
          guifg = vim.g.kanagawa_fg,
          guibg = vim.g.kanagawa_bg,
          breadcrumbs_section,
          has_diag and { diag } or {},
          git_diff_section,
          (not search_active) and { "", guifg = colors.bg, guibg = vim.g.kanagawa_bg }
            or { "", guibg = vim.g.kanagawa_bg, guifg = hl_attr("IncSearch", "bg") },
          (not search_active) and { " ", guifg = colors.fg, guibg = colors.bg } or {},
          (not search_active) and { icon, guifg = colors.fg, guibg = colors.bg } or {},
          (not search_active) and { " ", guifg = colors.fg, guibg = colors.bg } or {},
          (not search_active) and {
            filename,
            " ",
            { string.format("%d", props.buf), guifg = colors.fg, guibg = colors.bg },
            " ",
            { modified_icon, group = "InclineModified" },
            guifg = colors.fg,
            guibg = colors.bg,
          } or {},
          search_section,
        }
      end,
    })
  end,
}
