return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = "CopilotChat",
  build = "make tiktoken",
  opts = function()
    -- this is a test for the model
    local user = vim.env.USER or "User"
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      -- model = "deepseek-coder-v2:latest",
      auto_insert_mode = true,
      -- question_header = " " .. user .. " ",
      separator = "━━",
      headers = {
        user = " User (" .. user .. ") ",
        assistant = " Better User ",
        tool = " Tool ",
      },

      providers = {
        ollama = {
          prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
          prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,

          get_models = function(headers)
            local response, err = require("CopilotChat.utils.curl").get("http://localhost:11434/v1/models", {
              headers = headers,
              json_response = true,
            })

            if err then
              error(err)
            end

            return vim.tbl_map(function(model)
              return {
                id = model.id,
                name = model.id,
              }
            end, response.body.data)
          end,

          embed = function(inputs, headers)
            local response, err = require("CopilotChat.utils.curl").post("http://localhost:11434/v1/embeddings", {
              headers = headers,
              json_request = true,
              json_response = true,
              body = {
                input = inputs,
                model = "qwen2.5-coder:1.5b-base",
              },
            })

            if err then
              error(err)
            end

            return response.body.data
          end,

          get_url = function()
            return "http://localhost:11434/v1/chat/completions"
          end,
        },
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
