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

  config = function()
    vim.keymap.set("n", "<leader>tu", function()
      -- configure settings via Vim globalvim.keymap.set("n", "<leader>tu", function()
      local undotree_win = undotree_win_open()
      -- Check if Neo-tree is open by looking for a window with 'neo-tree' filetype
      local neotree_win = nil
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "neo-tree" then
          neotree_win = win
          break
        end
      end
      -- Only close Neo-tree if Undotree is NOT visible
      if not undotree_win and neotree_win then
        vim.cmd("Neotree close")
      end
      vim.cmd.UndotreeToggle()
    end, { desc = "Undotree" })
    vim.g.undotree_WindowLayout = 2 -- your layout config
    -- vim.g.undotree_SplitWidth = 40 -- your layout config
    vim.g.undotree_DiffpanelHeight = 15 -- example
    -- add any additional opts here
  end,
}
