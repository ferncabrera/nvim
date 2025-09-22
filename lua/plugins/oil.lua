return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      { "<space>-", function() require("oil").toggle_float() end, desc = "Open parent directory (float)" },
    },
    opts = {
      columns = { "icon" },
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["<M-h>"] = "actions.select_split",
      },
      win_options = {
        winbar = "  %{v:lua.require'oil'.get_winbar()}",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },
}
