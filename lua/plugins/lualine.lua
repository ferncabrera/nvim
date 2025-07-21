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
    opts.options.component_separators = { left = "╲", right = "╱" }
    opts.options.section_separators = { left = "", right = "" }
    opts.sections.lualine_y = {
      { "encoding", padding = { left = 1, right = 0 }, separator = "" },
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
        "progress",
        padding = { left = 0, right = 1 },
        fmt = function(str)
          return str .. " 󰇀"
        end,
      },
    }
  end,
}
