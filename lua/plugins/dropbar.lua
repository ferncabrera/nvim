return {
  "Bekaboo/dropbar.nvim",
  event = "VeryLazy", -- load after startup
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- optional, for file-type icons
  },
  config = function()
    require("dropbar").setup({
      bar = {
        -- you can customize your winbar here; by default it uses
        -- both LSP, Treesitter, markdown & path sources
      },
      -- menu, fzf, icons, highlight, etc. all live under opts.menu, opts.fzf, etc.
    })
    -- keymap to “pick” symbols in the winbar
    local dropbar_api = require("dropbar.api")
    vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Dropbar pick symbol" })
  end,
}
