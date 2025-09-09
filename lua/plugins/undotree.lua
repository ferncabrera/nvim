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
      local undotree_win = undotree_win_open()
      local pickers = require("snacks.picker.core.picker").get()
      -- Only close the picker if Undotree is NOT visible
      if not undotree_win and #pickers > 0 then
        pickers[#pickers]:close()
      end
      vim.cmd.UndotreeToggle()
    end, { desc = "Undotree" })
    -- configure settings via Vim globals
    vim.g.undotree_WindowLayout = 2 -- your layout config
    -- vim.g.undotree_SplitWidth = 40 -- your layout config
    vim.g.undotree_DiffpanelHeight = 15 -- example
    -- add any additional opts here
  end,
}
