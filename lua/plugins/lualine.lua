local function selectionCount()
  -- fetch the current mode every time
  local mode = vim.fn.mode()
  -- detect v, V, or <C‑V> (blockwise Visual is "\22")
  local is_visual = mode == "v" or mode == "V" or mode == "\22"

  if not is_visual then
    -- no selection: total lines in buffer
    return tostring(vim.fn.line("$"))
  end

  -- visual mode: count selected lines
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  local lines = math.abs(end_line - start_line) + 1
  return tostring(lines)
end

local function getWordsV2()
  if not vim.g.lualine_show_count_info then
    return ""
  end

  local wc = vim.fn.wordcount()
  local selection = selectionCount()

  if wc.visual_words then
    return string.format("%s:%s:%s ", selection, wc.visual_words, wc.visual_chars)
  else
    -- no selection: show total words/chars
    return string.format("%s:%s:%s ", selection, wc.words, wc.chars)
  end
end

return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  event = "VeryLazy",
  opts = function(_, opts)
    opts.extensions = { "oil" }
    opts.options.component_separators = { left = "╲", right = "╱" }
    opts.options.section_separators = { left = "", right = "" }

    local icons = LazyVim.config.icons
    opts.sections.lualine_c = {
      LazyVim.lualine.root_dir(),
      -- {
      --   "diagnostics",
      --   symbols = {
      --     error = icons.diagnostics.Error,
      --     warn = icons.diagnostics.Warn,
      --     info = icons.diagnostics.Info,
      --     hint = icons.diagnostics.Hint,
      --   },
      -- },
      -- { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      {
        LazyVim.lualine.pretty_path({
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = " ",
          readonly_icon = " 󰌾 ",
          length = 3,
        }),
      },
    }

    opts.sections.lualine_x = {
      Snacks.profiler.status(),
        -- stylua: ignore
        {
          function() return require("noice").api.status.command.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
          color = function() return { fg = Snacks.util.color("Statement") } end,
        },
        -- stylua: ignore
        {
          function() return require("noice").api.status.mode.get() end,
          cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
          color = function() return { fg = Snacks.util.color("Constant") } end,
        },
        -- stylua: ignore
        {
          function() return "  " .. require("dap").status() end,
          cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          color = function() return { fg = Snacks.util.color("Debug") } end,
        },
        -- stylua: ignore
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = function() return { fg = Snacks.util.color("Special") } end,
        },
      -- {
      -- "diff",
      -- symbols = {
      --   added = icons.git.added,
      --   modified = icons.git.modified,
      --   removed = icons.git.removed,
      -- },
      -- source = function()
      --   local gitsigns = vim.b.gitsigns_status_dict
      --   if gitsigns then
      --     return {
      --       added = gitsigns.added,
      --       modified = gitsigns.changed,
      --       removed = gitsigns.removed,
      --     }
      --   end
      -- end,
      -- },
    }

    table.insert(
      opts.sections.lualine_x,
      2,
      LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
        local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
        if #clients > 0 then
          local status = require("copilot.status").data.status
          return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
        end
      end)
    )

    -- if not vim.g.trouble_lualine then
    table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
    -- end

    opts.sections.lualine_y = {
      {
        "encoding",
        padding = { left = 1, right = 0 },
        separator = "",
        cond = function()
          return vim.g.lualine_show_filetype_info
        end,
      },
      {
        "filesize",
        padding = { left = 1, right = 1 },
        fmt = function(size)
          if size and size ~= "" then
            return size .. " "
          else
            return ""
          end
        end,
        separator = "╱",
        cond = function()
          return vim.g.lualine_show_filetype_info
        end,
      },
      { getWordsV2, padding = { left = 1, right = 1 }, separator = "╱" },
      -- {
      --   function()
      --     if vim.bo.buftype == "" then
      --       return getWordsV2()
      --     end
      --     return ""
      --   end,
      --   padding = { left = 1, right = 1 },
      --   separator = "|",
      -- },
      {
        function()
          if not vim.g.lualine_show_last_modified then
            return ""
          end

          local buftype = vim.bo.buftype
          if buftype ~= "" then
            return ""
          end

          local filepath = vim.fn.expand("%:p")
          local handle = io.popen("stat -f %B " .. vim.fn.shellescape(filepath))
          if not handle then
            return "N/A 󰚰"
          end
          local creation_date = handle:read("*a"):gsub("%s+", "")
          handle:close()
          if creation_date == "?" or creation_date == "" then
            return "N/A 󰚰"
          else
            return os.date("%Y %B %d %H:%M", tonumber(creation_date)) .. " 󰚰"
          end
        end,
        padding = { left = 1, right = 1 },
        separator = "╱",
      },
    }
    opts.sections.lualine_z = {
      { "location", separator = "", padding = { left = 0, right = 1 } },
      {
        function()
          local wc = vim.fn.wordcount()
          return "@" .. tostring(wc.cursor_chars or 0)
        end,
        separator = "",
        padding = { left = 0, right = 1 },
      },
      {
        "progress",
        padding = { left = 0, right = 1 },
        fmt = function(str)
          return str .. " 󰇀"
        end,
      },
    }
  end,
  vim.keymap.set("n", "<leader>tt", function()
    if vim.o.laststatus == 0 then
      vim.o.laststatus = 2
      vim.g.incline_show_navic = false
    else
      vim.o.laststatus = 0
      vim.g.incline_show_navic = true
    end
  end, { desc = "Toggle Lualine" }),
}
