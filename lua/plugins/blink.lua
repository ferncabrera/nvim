return {
  {
    "saghen/blink.cmp",
    version = "1.3.1",
    opts = {
      keymap = {
        preset = "super-tab",
      },
      completion = {
        -- list = {
        --   selection = "manual",
        -- },
        menu = {
          border = "rounded",
          -- winblend = vim.o.pumblend,
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      signature = {
        enabled = true,
        window = {
          winblend = vim.o.pumblend,
        },
      },
    },
  },
}
