-- the lang.sql extra provides cmd/dependencies/init (db_ui_* globals); only the key differs
return {
  "kristijanhusak/vim-dadbod-ui",
  keys = {
    {
      "<leader>D",
      function()
        -- If DBUI is not visible yet, close neo-tree first so the two side panels do not stack
        if vim.fn.bufwinnr("dbui") == -1 then
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
              vim.cmd("Neotree close")
              break
            end
          end
        end
        vim.cmd("DBUIToggle")
      end,
      desc = "Toggle DBUI",
    },
  },
}
