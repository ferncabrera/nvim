return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 999,
  config = function()
    local colors = require("kanagawa.colors").setup()
    vim.api.nvim_set_hl(0, "InclineModified", {
      -- bg = colors.palette.sakuraPink,
      fg = "#EEF5FF",
    })
    require("incline").setup({
      ignore = {
        floating_wins = false,
        wintypes = function(winid, wintype)
          local zen_view = package.loaded["zen-mode.view"]
          if zen_view and zen_view.is_open() then
            return winid ~= zen_view.win
          end
          return wintype ~= ""
        end,
      },
      highlight = {
        groups = {
          InclineNormal = { guibg = "#b35b79", guifg = "#f2ecbc" },
          InclineNormalNC = { guibg = "#d9a594", guifg = "#f2ecbc" },
        },
      },
      window = {
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
      },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local modified_icon = vim.bo[props.buf].modified and "" or ""

        local function get_git_diff()
          local icons = { removed = "", changed = "", added = "" }
          local signs = vim.b[props.buf].gitsigns_status_dict
          local labels = {}
          if signs == nil then
            return labels
          end
          for name, icon in pairs(icons) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { icon .. signs[name] .. " ", group = "Diff" .. name })
            end
          end
          if #labels > 0 then
            table.insert(labels, { "" })
          end
          return labels
        end

        local function get_diagnostic_label()
          local icons = { error = "", warn = "", info = "", hint = "" }
          local label = {}

          for severity, icon in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icon .. n .. " ", group = "DiagnosticSign" .. severity })
            end
          end
          if #label > 0 then
            table.insert(label, { "┊ " })
          end
          return label
        end

        local icon, color = require("nvim-web-devicons").get_icon_color(filename)
        if not icon or icon == "" then
          icon = "󰈔"
        end

        return {
          -- { get_diagnostic_label() },
          { " ", get_git_diff(), guifg = vim.g.kanagawa_fg, guibg = vim.g.kanagawa_bg },
          { " " },
          { icon, guifg = color },
          { " " },
          { filename, " ", { modified_icon, group = "InclineModified" } },
        }
      end,
    })
  end,
}
