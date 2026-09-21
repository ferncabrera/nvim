return {
  {
    "rebelot/kanagawa.nvim",
    lazy = true, -- lazy.nvim loads it on ColorSchemePre when LazyVim runs :colorscheme kanagawa
    config = function()
      require("config.kanagawa")
    end,
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "kanagawa" } },
  -- LazyVim's default colorscheme was still loaded first (full highlight pass + every ColorScheme
  -- autocmd firing twice) before kanagawa did `hi clear` and repainted.
  { "folke/tokyonight.nvim", enabled = false },
}
