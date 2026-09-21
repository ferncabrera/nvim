local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "LazyFile",
  main = "ibl",
  -- requiring ibl.hooks at spec-parse time made lazy.nvim load the plugin eagerly; LazyVim's extra already
  -- registers <leader>ug and the filetype excludes. The rainbow-delimiters hook that was here targeted a
  -- plugin that is not installed (scope colours still cycle by depth without it).
  opts = function(_, opts)
    local hooks = require("ibl.hooks")
    -- create the highlight groups in the highlight setup hook, so they are reset every time the colorscheme changes
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#b35b79" })
      vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
      vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
      vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
      vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
    end)
    opts.indent = { char = "│", tab_char = "│", highlight = "LineNr" }
    opts.scope = { show_start = true, show_end = true, highlight = highlight }
    return opts
  end,
}
