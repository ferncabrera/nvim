return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy", -- load lazily
  priority = 1000, -- load before other diagnostics
  config = function()
    require("tiny-inline-diagnostic").setup() -- use default settings
  end,
}
