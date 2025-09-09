return {
  "kristijanhusak/vim-dadbod-ui",
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  dependencies = "vim-dadbod",
  keys = {
    {
      "<leader>D",
      function()
        local pickers = require("snacks.picker.core.picker").get()

        -- Check if DBUI window is visible
        local dbui_win = vim.fn.bufwinnr("dbui") ~= -1

        -- If DBUI window is NOT visible, close the snacks picker (if any)
        if not dbui_win and #pickers > 0 then
          pickers[#pickers]:close()
        end

        -- Always toggle DBUI after handling snacks picker logic
        vim.cmd("DBUIToggle")
      end,
      desc = "Toggle DBUI",
    },
  },
  init = function()
    local data_path = vim.fn.stdpath("data")

    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
    vim.g.db_ui_show_database_icon = true
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
    vim.g.db_ui_use_nerd_fonts = true
    vim.g.db_ui_use_nvim_notify = true
    vim.g.db_ui_execute_on_save = false
  end,
}
