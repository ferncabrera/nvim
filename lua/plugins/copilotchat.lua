return {
  "CopilotC-Nvim/CopilotChat.nvim",
  -- branch = "main", //BROKEN, cannot tab-accept any buffer inputs
  -- version = "3.12.2",
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
    {
      "<leader>aa",
      function()
        local pickers = require("snacks.picker.core.picker").get()
        if #pickers > 0 then
          pickers[#pickers]:close()
        end
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "Select Models (CopilotChat)" },
  },
}
