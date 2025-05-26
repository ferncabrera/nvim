return {
  "CopilotC-Nvim/CopilotChat.nvim",
  brancjh = "main",
  cmd = "CopilotChat",
  opts = function()
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      -- model = "gpt-4.1",
      auto_insert_mode = true,
      question_header = " " .. user .. " ",
    }
  end,
  keys = {
    { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "Select Models (CopilotChat)" },
  },
}
