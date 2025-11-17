return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      {
        "-",
        function()
          local pickers = require("snacks.picker.core.picker").get()
          if #pickers > 0 then
            pickers[#pickers]:close()
          end
          vim.cmd("Oil")
        end,
        desc = "Open parent directory",
      },
    },
    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      cleanup_delay_ms = 2500,
      delete_to_trash = true,
      buf_options = {
        buflisted = true,
      },
      keymaps = {
        ["gd"] = {
          desc = "Discard all changed made to Oil Buffers",
          callback = function()
            require("oil").discard_all_changes()
          end,
        },
        ["ga"] = {
          desc = "Toggle file detail view",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["q"] = { "actions.close", mode = "n" },
        ["-"] = { "actions.parent", mode = "n" },
        ["<BS>"] = { "actions.parent", mode = "n" },
        ["~"] = false,
        ["`"] = false,
        ["<C-\\>"] = { "actions.cd", opts = { scope = "global" }, mode = "n" },
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
