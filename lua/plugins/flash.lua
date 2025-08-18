local function setupCustomHighlightGroup()
  vim.api.nvim_command("hi clear FlashMatch")
  vim.api.nvim_command("hi clear FlashCurrent")
  vim.api.nvim_command("hi clear FlashLabel")

  -- vim.api.nvim_command("hi FlashMatch guibg=#938AA9 guifg=#EEF5FF") -- Emerald background
  vim.api.nvim_command("hi FlashLabel guibg=#ff007c guifg=#EEF5FF")
  vim.api.nvim_command("hi FlashCurrent guibg=#009fff guifg=#EEF5FF")
  vim.api.nvim_command("hi FlashPromptIcon guifg=#ff007c")
end

return {
  "folke/flash.nvim",
  ---@type Flash.Config
  opts = {
    rainbow = {
      enabled = true,
      shade = 5,
    },
    highlight = {
      backdrop = true,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
  },
  config = function()
    setupCustomHighlightGroup()
  end,
}
