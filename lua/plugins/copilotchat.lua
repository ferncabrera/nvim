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
      -- question_header = " " .. user .. " ",
      separator = "━━",
      headers = {
        user = " User (" .. user .. ") ", -- Header to use for user questions
        assistant = " Copilot ", -- Header to use for AI answers
        tool = " Tool ", -- Header to use for tool calls
      },
    }
  end,
  keys = {
    {
      "<leader>aa",
      function()
        local copilot_chat = require("CopilotChat").chat
        local pickers = require("snacks.picker.core.picker").get()

        -- If CopilotChat window is NOT visible, close the snacks picker (if any)
        if not copilot_chat:visible() and #pickers > 0 then
          pickers[#pickers]:close()
        end

        -- Always toggle CopilotChat after handling snacks picker logic
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "Select Models (CopilotChat)" },
  },
}
