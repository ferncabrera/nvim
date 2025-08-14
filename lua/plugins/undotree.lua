return {
  "mbbill/undotree",

  config = function()
    vim.keymap.set("n", "<leader>tu", function()
      local pickers = require("snacks.picker.core.picker").get()
      if #pickers > 0 then
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
