return {
  "cbochs/grapple.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    scope = "global", -- also try out "git_branch"
    icons = true, -- setting to "true" requires "nvim-web-devicons"
    status = false,
    style = "basename",
  },
  keys = {
    { "<leader>H", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
    { "<leader>h", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

    { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
    { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
    { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
    { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },
    { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Select fifth tag" },
    { "<leader>6", "<cmd>Grapple select index=6<cr>", desc = "Select sixth tag" },
    { "<leader>7", "<cmd>Grapple select index=7<cr>", desc = "Select seventh tag" },
    { "<leader>8", "<cmd>Grapple select index=8<cr>", desc = "Select eighth tag" },
    { "<leader>9", "<cmd>Grapple select index=9<cr>", desc = "Select ninth tag" },

    { "<c-s-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
    { "<c-s-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
  },
}
