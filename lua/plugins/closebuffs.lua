return {
  "kazhala/close-buffers.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>th",
      function()
        require("close_buffers").delete({ type = "hidden" })
      end,
      desc = "Close Hidden Buffers",
    },
    {
      "<leader>tn",
      function()
        require("close_buffers").delete({ type = "nameless" })
      end,
      desc = "Close Nameless Buffers",
    },
  },
}
