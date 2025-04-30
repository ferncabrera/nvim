-- lua/plugins/colorschemes.lua
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false, -- load immediately (so our colorscheme isn’t overridden later)
    priority = 1000, -- load before any other colorscheme
    config = function()
      require("config.kanagawa")

      vim.cmd("colorscheme kanagawa") -- :contentReference[oaicite:0]{index=0}
    end,
  },
}
