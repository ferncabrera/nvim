return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 1200,
  config = function()
    vim.api.nvim_set_hl(0, "InclineModified", { fg = "#B02669" })
    require("incline").setup({
      -- highlight = {
      --   groups = {
      --     InclineNormal = { guibg = colors.magenta500, guifg = colors.base04 },
      --     InclineNormalNC = { guifg = colors.violet500, guibg = colors.base03 },
      --   },
      -- },
      window = { margin = { vertical = 0, horizontal = 1 } },
      hide = {
        cursorline = false,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
        local modified_icon = vim.bo[props.buf].modified and "[󰦒] " or ""

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
            table.insert(labels, { "┊ " })
          end
          return labels
        end

        local function get_diagnostic_label()
          local icons = { error = "", warn = "", info = "", hint = "" }
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

        return {
          { get_diagnostic_label() },
          { get_git_diff() },
          { icon, guifg = color },
          { " " },
          { { modified_icon, group = "InclineModified" }, filename },
        }
      end,
    })
  end,
}
