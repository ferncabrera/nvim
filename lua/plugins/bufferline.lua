return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  -- keys = {
  --   { "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab", noremap = true, mode = "n" },
  --   { "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab", noremap = true, mode = "n" },
  -- },
  opts = {
    options = {
      hover = {
        enabled = false,
        delay = 200,
        reveal = { "close" },
      },
      diagnostics = "nvim_lsp",
      mode = "tabs",
      separator_style = { "", "" },
      show_buffer_close_icons = false,
      show_close_icon = false,
      indicator = {
        icon = "",
        style = "icon",
      },
    },
  },
}
