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
    local c = colors.theme
    return {
      WinSeparator = { fg = c.ui.border, bg = c.ui.bg },
      Pmenu = { fg = c.ui.shade0, bg = c.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency,,
      PmenuSel = { fg = "NONE", bg = c.ui.bg_p2 },
      PmenuSbar = { bg = c.ui.bg_m1 },
      PmenuThumb = { bg = "#C0A36E" },
      BlinkCmpMenuBorder = { fg = "", bg = "" },

      -- LineNr = { fg = "#C0A36E", bg = "NONE" },
      CursorLineNr = { fg = colors.palette.sakuraPink, bg = "NONE" },
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },

      -- A “dark” Normal highlight with dimmed fg for use in e.g. terminals
      NormalDark = { fg = c.ui.fg_dim, bg = c.ui.bg_m3 },

      -- Popular float-based plugins (Lazy, Mason)
      LazyNormal = { fg = c.ui.fg_dim, bg = c.ui.bg_m3 },
      MasonNormal = { fg = c.ui.fg_dim, bg = c.ui.bg_m3 },
    }
  end,
})
