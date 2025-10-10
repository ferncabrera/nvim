return {
  "mikavilpas/yazi.nvim",
  version = "*", -- use the latest stable version
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim", lazy = true },
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      "<leader>-",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>E",
      mode = { "n", "v" },
      "<cmd>Yazi cwd<cr>",
      desc = "Open yazi in nvim's working directory",
    },
    {
      "<leader>e",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>se",
      mode = { "n", "v" },
      function()
        if vim.g.yazi_has_session then
          vim.cmd("Yazi toggle")
        else
          vim.notify("No Yazi session to resume!", vim.log.levels.WARN)
          vim.cmd("Yazi")
        end
      end,
      desc = "Resume the last yazi session",
    },
  },
  opts = {
    hooks = {
      yazi_opened = function(preselected_path, yazi_buffer_id, config)
        vim.g.yazi_has_session = true
      end,
      yazi_closed_successfully = function(chosen_file, config, state) end,
    },
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true,
    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",
      open_and_pick_window = "<c-o>",
    },
    change_neovim_cwd_on_close = false,
    integrations = {
      grep_in_selected_files = "snacks.picker",
      grep_in_directory = "snacks.picker",
      picker_add_copy_relative_path_action = "snacks.picker",
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  init = function()
    -- mark netrw as loaded so it's not loaded at all.
    --
    -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
    vim.g.loaded_netrwPlugin = 1
  end,
}
