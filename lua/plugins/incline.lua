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
-- nerd-font glyphs as escapes: private-use-area characters are invisible in most diff tools
local diag_icons = {
  { sev.ERROR, "\u{F00D}", "DiagnosticSignError" },
  { sev.WARN, "\u{F071}", "DiagnosticSignWarn" },
  { sev.INFO, "\u{F05A}", "DiagnosticSignInfo" },
  { sev.HINT, "\u{F4E0}", "DiagnosticSignHint" },
}
local function diag_items(buf)
  local counts, out = vim.diagnostic.count(buf), {} -- one call instead of four list copies
  for _, d in ipairs(diag_icons) do
    if counts[d[1]] then
      out[#out + 1] = { d[2] .. counts[d[1]], group = d[3] }
    end
  end
  return out
end

local git_icons = { removed = "\u{F458}", changed = "\u{F459}", added = "\u{F457}" }
local function git_items(buf)
  local signs = vim.b[buf].gitsigns_status_dict
  local out = {}
  if signs == nil then
    return out
  end
  for _, name in ipairs({ "added", "changed", "removed" }) do -- stable order (pairs() shuffled it)
    if tonumber(signs[name]) and signs[name] > 0 then
      out[#out + 1] = { git_icons[name] .. signs[name], group = "Diff" .. name }
    end
  end
  return out
end

-- Flatten an item into leaf items that each carry an explicit fg + bg. incline turns every table with
-- attributes into one highlight extmark; when several same-priority marks start on the same column
-- (a container plus its first child) Neovim does not reliably pick the innermost, so the info block
-- never uses a container background: each cell gets exactly one mark.
local function with_bg(item, bg, out)
  out = out or {}
  if type(item) == "string" then
    out[#out + 1] = { item, guibg = bg }
  elseif item[1] ~= nil and type(item[1]) == "string" and #item == 1 then
    -- leaf: { text, group=... } or { text, guifg=... }
    local fg = item.guifg or (item.group and hl_attr(item.group, "fg")) or nil
    out[#out + 1] = { item[1], guifg = fg, guibg = bg }
  else
    for _, child in ipairs(item) do
      with_bg(child, bg, out)
    end
  end
  return out
end

-- items separated by `sep`
local function join(items, sep)
  local out = {}
  for i, item in ipairs(items) do
    if i > 1 then
      out[#out + 1] = sep
    end
    out[#out + 1] = item
  end
  return out
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
        if filename == "" then
          filename = "\u{F420}"
        end
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

        -- Info fields (navic > diagnostics > git), each computed once, only for the focused window
        local fields = {}
        if vim.g.incline_show_navic and props.focused and navic.is_available(props.buf) then
          local crumbs = {}
          for _, item in ipairs(navic.get_data(props.buf) or {}) do
            crumbs[#crumbs + 1] = {
              { item.icon, guifg = hl_attr("NavicIcons" .. item.type, "fg") },
              { item.name, guifg = hl_attr("NavicText", "fg") },
            }
          end
          if #crumbs > 0 then
            fields[#fields + 1] = join(crumbs, { " \u{EAB6} ", guifg = hl_attr("NavicSeparator", "fg") })
          end
        end
        if vim.g.incline_show_diagnostics and props.focused then
          vim.list_extend(fields, diag_items(props.buf))
        end
        if vim.g.incline_show_git_diff and props.focused then
          vim.list_extend(fields, git_items(props.buf))
        end

        -- The visible fields form one block with its own background and a rounded outer cap (U+E0B6),
        -- joined seamlessly to the filename pill: the pill's own edge is drawn on the block colour when
        -- any field is shown and on the editor background otherwise. No fields -> no block, no cap.
        local has_fields = #fields > 0
        local info_bg = vim.g.kanagawa_bg_p1 or vim.g.kanagawa_bg
        local info_block = {}
        if has_fields then
          info_block[1] = { "\u{E0B6}", guifg = info_bg, guibg = vim.g.kanagawa_bg } -- outer rounded cap
          with_bg({ " ", join(fields, " "), " " }, info_bg, info_block)
        end
        local edge_bg = has_fields and info_bg or vim.g.kanagawa_bg

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
          info_block,
          (not search_active) and { "\u{E0B6}", guifg = colors.bg, guibg = edge_bg }
            or { "\u{E0B6}", guibg = edge_bg, guifg = hl_attr("IncSearch", "bg") },
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
