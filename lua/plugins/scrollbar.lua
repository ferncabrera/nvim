return {
  {
    "petertriho/nvim-scrollbar",
    dependencies = {
      "kevinhwang91/nvim-hlslens",
    },
    config = function()
      require("scrollbar").setup()
      require("scrollbar.handlers.search").setup()
    end,
  },
}
