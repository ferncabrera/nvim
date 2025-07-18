local highlight = {
  "CursorColumn",
  "Whitespace",
}

return {
  "lukas-reineke/indent-blankline.nvim",
  event = "LazyFile",
  opts = function()
    Snacks.toggle({
      name = "Indention Guides",
      get = function()
        return require("ibl.config").get_config(0).enabled
      end,
      set = function(state)
        require("ibl").setup_buffer(0, { enabled = state })
      end,
    }):map("<leader>ug")

    return {
      indent = {
        char = "│",
        tab_char = "│",
      },
      -- indent = { highlight = highlight, char = "" },
      -- whitespace = {
      --   highlight = highlight,
      --   remove_blankline_trail = false,
      -- },
      scope = { show_start = true, show_end = true },
      exclude = {
        filetypes = {
          "Trouble",
          "alpha",
          "dashboard",
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "notify",
          "snacks_dashboard",
          "snacks_notif",
          "snacks_terminal",
          "snacks_win",
          "toggleterm",
          "trouble",
        },
      },
    }
  end,
  main = "ibl",
}
