local function undotree_win_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "undotree" then
      return true
    end
  end
  return false
end

return {
  "mbbill/undotree",
  cmd = { "UndotreeToggle", "UndotreeShow" },
  init = function()
    vim.g.undotree_WindowLayout = 2
    -- vim.g.undotree_SplitWidth = 40
    vim.g.undotree_DiffpanelHeight = 15
  end,
  keys = {
    {
      "<leader>tu",
      function()
        -- Only close Neo-tree if Undotree is NOT visible
        if not undotree_win_open() then
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
              vim.cmd("Neotree close")
              break
            end
          end
        end
        vim.cmd.UndotreeToggle()
      end,
      desc = "Undotree (tree view)", -- distinct from LazyVim's <leader>su Snacks undo picker
    },
  },
}
