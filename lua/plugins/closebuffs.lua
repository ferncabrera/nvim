return {
  "kazhala/close-buffers.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>t", "", desc = "+custom/primagen", mode = { "n", "v" } },
    {
      "<leader>bh",
      function()
        local closed = require("close_buffers").delete({ type = "hidden" })
        vim.notify("Closed hidden buffers.", vim.log.levels.INFO)
      end,
      desc = "Close Hidden Buffers",
    },
    {
      "<leader>bn",
      function()
        local closed = require("close_buffers").delete({ type = "nameless" })
        vim.notify("Closed nameless buffers.", vim.log.levels.INFO)
      end,
      desc = "Close Nameless Buffers",
    },
  },
}
