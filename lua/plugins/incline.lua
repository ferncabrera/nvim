return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  priority = 999,
  config = function()
    vim.api.nvim_set_hl(0, "InclineModified", {
      fg = "#EEF5FF",
    })

    -- local helpers = require("incline.helpers")
    local navic = require("nvim-navic") -- add navic
    local devicons = require("nvim-web-devicons")

    -- local function get_lualine_colors(lualine, props, ft_color)
    --   local fg, bg, ifg, ibg
    --   local theme_name = lualine.get_config().options.theme
    --   local theme = require("lualine.themes." .. theme_name)
    --
    --   ifg = helpers.contrast_color(ft_color)
    --   ibg = ft_color
    --
    --   if not props.focused then
    --     fg = theme.inactive.a.fg
    --     bg = theme.inactive.a.bg
    --     ifg = fg
    --     ibg = bg
    --   elseif vim.fn.mode():match("n") then
    --     fg = theme.normal.a.fg
    --     bg = theme.normal.a.bg
    --   elseif vim.fn.mode():match("i") then
    --     fg = theme.insert.a.fg
    --     bg = theme.insert.a.bg
    --   elseif vim.fn.mode():match("R") then
    --     fg = theme.replace.a.fg
    --     bg = theme.replace.a.bg
    --   elseif vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "\22" then
    --     fg = theme.visual.a.fg
    --     bg = theme.visual.a.bg
    --   else
    --     fg = theme.normal.a.fg
    --     bg = theme.normal.a.bg
    --   end
    --
    --   return { fg = fg, bg = bg, ifg = ifg, ibg = ibg }
    -- end

    local function get_fallback_colors(props)
      if not props.focused then
        if MODE == "dark" then
          if THEME == "wave" then
            return { fg = "#dcd7ba", bg = "#2a2a37", ifg = "#dcd7ba", ibg = "#2a2a37" }
          else
            return { fg = "#f2ecbc", bg = "#393836", ifg = "#f2ecbc", ibg = "#393836" }
          end
        else
          return { fg = "#f2ecbc", bg = "#938056", ifg = "#f2ecbc", ibg = "#938056" }
        end
      else
        if MODE == "dark" then
          if THEME == "wave" then
            return { fg = "#dcd7ba", bg = "#545464", ifg = "#dcd7ba", ibg = "#54546D" }
          else
            return { fg = "#f2ecbc", bg = "#625e5a", ifg = "#f2ecbc", ibg = "#625e5a" }
          end
        else
          return { fg = "#f2ecbc", bg = "#d9a594", ifg = "#f2ecbc", ibg = "#d9a594" }
        end
      end
    end

    local function get_colors(props, ft_color)
      if not ft_color then
        ft_color = "#000000"
      end
      -- local status, lualine = pcall(require, "lualine")
      -- local colors
      -- if status then
      --   colors = get_lualine_colors(lualine, props, ft_color)
      -- end
      -- return colors or get_fallback_colors(props, ft_color)
      return get_fallback_colors(props)
    end

    require("incline").setup({
      ignore = {
        unlisted_buffers = true,
        floating_wins = true,
        wintypes = function(winid, wintype)
          local zen_view = package.loaded["zen-mode.view"]
          if zen_view and zen_view.is_open() then
            return winid ~= zen_view.win
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
      },
      hide = {
        cursorline = true,
      },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")

        if filename == "" then
          filename = ""
        end

        local modified_icon = vim.bo[props.buf].modified and "⚪" or ""

        local icon, ft_color = devicons.get_icon_color(filename)
        if vim.bo[props.buf].filetype == "oil" then
          filename = "Oil:///"
          icon = "󰙅"
          ft_color = "#FFFFFF"
        else
          icon, ft_color = devicons.get_icon_color(filename)
          if not icon or icon == "" then
            icon = "󰈔"
          end
        end

        local colors = get_colors(props, ft_color)

        -- Git diff (unchanged)
        function _G.InclineGetGitDiff(buf)
          buf = buf or vim.api.nvim_get_current_buf()
          local icons = { removed = "", changed = "", added = "" }
          local signs = vim.b[buf].gitsigns_status_dict
          local labels = {}
          if signs == nil then
            return labels
          end
          for name, icon_git in pairs(icons) do
            if tonumber(signs[name]) and signs[name] > 0 then
              table.insert(labels, { icon_git .. signs[name] .. " ", group = "Diff" .. name })
            end
          end
          if #labels > 0 then
            table.insert(labels, { "" })
          end
          return labels
        end

        -- Diagnostic info (unchanged)
        local function get_diagnostic_label()
          local icons = { error = "", warn = "", info = "", hint = "" }
          local label = {}
          for severity, icon_diag in pairs(icons) do
            local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
            if n > 0 then
              table.insert(label, { icon_diag .. n .. " ", group = "DiagnosticSign" .. severity })
            end
          end
          if #label > 0 then
            table.insert(label, { "" })
          end
          if #label > 0 then
            return { " ", label }
          else
            return {}
          end
        end

        -- Git diff section
        local git_diff = _G.InclineGetGitDiff(props.buf)
        local has_git_diff = #git_diff > 0
        local has_diagnostics = #get_diagnostic_label() > 0

        local git_diff_section = has_git_diff
            and props.focused
            and vim.g.incline_show_git_diff
            and {
              vim.g.incline_show_diagnostics and has_diagnostics and "" or " ",
              git_diff,
            }
          or {}

        local function get_hl_fg(group)
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
          if ok and hl and hl.fg then
            return string.format("#%06x", hl.fg)
          end
          return nil
        end

        -- Navic breadcrumbs
        local breadcrumbs = {}
        if props.focused and navic.is_available() then
          for _, item in ipairs(navic.get_data(props.buf) or {}) do
            table.insert(breadcrumbs, {
              { " ", guifg = get_hl_fg("NavicSeparator") },
              { item.icon, guifg = get_hl_fg("NavicIcons" .. item.type) },
              { item.name, guifg = get_hl_fg("NavicText") },
            })
          end
        end

        local breadcrumbs_section = {}
        local show_breadcrumbs_space = false
        if #breadcrumbs > 0 and vim.g.incline_show_navic then
          local show_diag = vim.g.incline_show_diagnostics and props.focused and #get_diagnostic_label() > 0
          local show_git = vim.g.incline_show_git_diff and props.focused and #git_diff > 0
          show_breadcrumbs_space = not (show_diag or show_git)
          if not (vim.g.incline_show_diagnostics or vim.g.incline_show_git_diff) then
            show_breadcrumbs_space = true
          end
          if show_breadcrumbs_space then
            breadcrumbs_section = { breadcrumbs, { " " } }
          else
            breadcrumbs_section = { breadcrumbs }
          end
        end

        local search_section = {}
        local search_active = false
        local search_section_icon
        if props.focused then
          local count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
          local contents = vim.fn.getreg("/")
          search_section_icon = { " 󱎸", group = "IncSearch" }
          if vim.v.hlsearch == 1 and count.total > 0 then
            search_active = true
            search_section = {
              search_section_icon,
              { (" \\<%s>\\"):format(contents), group = "IncSearch" },
              {
                (" [%d/%d] "):format(count.current, count.total),
                -- group = "dkoStatusValue"
                group = "IncSearch",
              },
              { modified_icon .. " ", group = "IncSearch" },
            }
          end
        end

        return {
          guifg = vim.g.kanagawa_fg,
          guibg = vim.g.kanagawa_bg,
          breadcrumbs_section,
          vim.g.incline_show_diagnostics and props.focused and { get_diagnostic_label() } or {},
          git_diff_section,
          (not search_active) and { " ", guifg = colors.fg, guibg = colors.bg } or {},
          (not search_active) and { icon, guifg = colors.fg, guibg = colors.bg } or {},
          (not search_active) and { " ", guifg = colors.fg, guibg = colors.bg } or {},
          (not search_active) and {
            filename,
            " ",
            { modified_icon, group = "InclineModified" },
            " ",
            guifg = colors.fg,
            guibg = colors.bg,
          } or {},
          search_section,
        }
      end,
    })
  end,
}
