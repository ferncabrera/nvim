return {
  "kazhala/close-buffers.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>th",
      function()
        local closed = require("close_buffers").delete({ type = "hidden" })
        vim.notify("Closed hidden buffers.", vim.log.levels.INFO)
      end,
      desc = "Close Hidden Buffers",
    },
    {
      "<leader>tn",
      function()
        local closed = require("close_buffers").delete({ type = "nameless" })
        vim.notify("Closed nameless buffers.", vim.log.levels.INFO)
      end,
      desc = "Close Nameless Buffers",
    },
  },
}
