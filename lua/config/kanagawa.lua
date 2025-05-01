-- lua/config/kanagawa.lua
local kanagawa = require("kanagawa")

kanagawa.setup({
  -- explicitly choose the wave theme
  theme = "lotus",

  -- map `vim.o.background` to your preferred variants:
  background = {
    dark = "wave", -- when background=dark → use wave
    light = "lotus", -- if you ever switch to background=light
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
