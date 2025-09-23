return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
      {
        "<space>-",
        function()
          require("oil").toggle_float()
        end,
        desc = "Open parent directory (float)",
      },
    },
    opts = {
      default_file_explorer = false,
      columns = { "icon" },
      keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["q"] = { "actions.close", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["<C-l>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,
        ["<M-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<M-v>"] = { "actions.select", opts = { vertical = true } },
      },
      -- win_options = {
      --   winbar = "%!v:lua.get_oil_winbar()",
      -- },
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git"
        end,
      },
    },
    config = function(_, opts)
      function _G.get_oil_winbar()
        local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
        local dir = require("oil").get_current_dir(bufnr)
        if dir then
          return vim.fn.fnamemodify(dir, ":~")
        else
          -- If there is no current directory (e.g. over ssh), just show the buffer name
          return vim.api.nvim_buf_get_name(0)
        end
      end
      require("oil").setup(opts)
    end,
  },
}
