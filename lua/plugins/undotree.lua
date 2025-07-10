return {
  "mbbill/undotree",

  config = function()
    vim.keymap.set("n", "<leader>tu", vim.cmd.UndotreeToggle, { desc = "Better undotree!!!" })
    -- configure settings via Vim globals
    vim.g.undotree_WindowLayout = 2 -- your layout config
    -- vim.g.undotree_SplitWidth = 40 -- your layout config
    vim.g.undotree_DiffpanelHeight = 15 -- example
    -- add any additional opts here
  end,
}
