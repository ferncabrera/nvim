-- lua/config/kanagawa.lua
local kanagawa = require("kanagawa")

kanagawa.setup({
  -- 'background' is the single switch: set at startup from the macOS appearance (init.lua) or by
  -- <leader>ub. (The 0.12 TUI does not subscribe to terminal theme-change notifications, so it does
  -- not follow macOS live; :restart / <leader>ub after switching appearance.)
  background = {
    dark = "dragon",
    light = "lotus",
  },

  -- your other customizations:
  compile = false,
  undercurl = true,
  commentStyle = { italic = true },
  keywordStyle = { italic = true },
  statementStyle = { bold = true },
  transparent = false,
  dimInactive = false,
  terminalColors = true,

  colors = {
    theme = {
      all = {
        -- tweak palette if you like
        ui = { bg_gutter = "none" },
      },
    },
  },

  overrides = function(colors)
    local theme = colors.theme
    -- vim.g.kanagawa_bg/fg/variant (used by incline + the statusline) are set by the ColorScheme
    -- handler in lua/config/autocmds.lua, so they also follow light/dark switches

    local makeDiagnosticColor = function(color)
      local c = require("kanagawa.lib.color")
      return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
    end
    return {
      DiagnosticVirtualTextHint = makeDiagnosticColor(theme.diag.hint),
      DiagnosticVirtualTextInfo = makeDiagnosticColor(theme.diag.info),
      DiagnosticVirtualTextWarn = makeDiagnosticColor(theme.diag.warning),
      DiagnosticVirtualTextError = makeDiagnosticColor(theme.diag.error),

      WinSeparator = { fg = theme.ui.border, bg = theme.ui.bg },

      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },

      BlinkCmpMenuBorder = { fg = "", bg = "" },

      CursorLineNr = { fg = colors.palette.sakuraPink, bg = "NONE" },

      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },

      -- A “dark” Normal highlight with dimmed fg for use in e.g. terminals
      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

      -- Popular float-based plugins (Lazy, Mason)
      LazyNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
      MasonNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
    }
  end,
})
