return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 999,
  config = function()
    vim.api.nvim_set_hl(0, "InclineModified", {
      -- bg = colors.palette.sakuraPink,
      fg = "#EEF5FF",
    })

    local helpers = require("incline.helpers")
    local devicons = require("nvim-web-devicons")

    local function get_lualine_colors(lualine, props, ft_color)
      local fg, bg, ifg, ibg
      local theme_name = lualine.get_config().options.theme
      local theme = require("lualine.themes." .. theme_name)
      local m = vim.api.nvim_get_mode().mode

      ifg = helpers.contrast_color(ft_color)
      ibg = ft_color

      if not props.focused then
        fg = theme.inactive.a.fg
        bg = theme.inactive.a.bg
        ifg = fg
        ibg = bg
      elseif vim.fn.mode():match("n") then
        fg = theme.normal.a.fg
        bg = theme.normal.a.bg
      elseif vim.fn.mode():match("i") then
        fg = theme.insert.a.fg
        bg = theme.insert.a.bg
      elseif vim.fn.mode():match("R") then
        fg = theme.replace.a.fg
        bg = theme.replace.a.bg
      elseif vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "\22" then
        fg = theme.visual.a.fg
        bg = theme.visual.a.bg
      else
        fg = "#000000"
        bg = "#ffffff"
      end

      return { fg = fg, bg = bg, ifg = ifg, ibg = ibg }
    end

    local function get_fallback_colors(props, ft_color)
      if not props.focused then
        return { fg = "#f2ecbc", bg = "#d9a594", ifg = "#f2ecbc", ibg = "#d9a594" }
      else
        return { fg = "#f2ecbc", bg = "#b35b79", ifg = "#f2ecbc", ibg = "#b35b79" }
      end
    end

    local function get_colors(props, ft_color)
      if not ft_color then
        ft_color = "#000000"
      end
      local status, lualine = pcall(require, "lualine")
      local colors
      if status then
        colors = get_lualine_colors(lualine, props, ft_color)
      end
      return colors or get_fallback_colors(props, ft_color)
    end

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
      -- highlight = {
      --   groups = {
      --     InclineNormal = { guibg = "#b35b79", guifg = "#f2ecbc" },
      --     InclineNormalNC = { guibg = "#d9a594", guifg = "#f2ecbc" },
      --   },
      -- },
      window = {
        padding = 0,
        margin = { horizontal = 0, vertical = 0 },
      },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")

        if filename == "" then
          filename = ""
        end

        local modified_icon = vim.bo[props.buf].modified and "" or ""

        local colors = get_colors(props, ft_color)

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

        local git_diff = get_git_diff()
        local git_diff_section = #git_diff > 0
            and props.focused
            and { " ", git_diff, guifg = vim.g.kanagawa_fg, guibg = vim.g.kanagawa_bg }
          or {}

        return {
          -- { get_diagnostic_label() },
          git_diff_section,
          { " " },
          { icon, guifg = color },
          { " " },
          { filename, " ", { modified_icon, group = "InclineModified" }, " " },
          guifg = colors.fg,
          guibg = colors.bg,
        }
      end,
    })
    vim.api.nvim_create_autocmd("ModeChanged", {
      callback = function()
        require("incline").refresh()
      end,
    })
  end,
}
