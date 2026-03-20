return {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = "CopilotChat",
  build = "make tiktoken",
  opts = function()
    -- this is a test for the model
    local user = vim.env.USER or "User"
    local copilot = require("CopilotChat")
    user = user:sub(1, 1):upper() .. user:sub(2)
    return {
      model = "claude-opus-4.5",
      auto_insert_mode = false,
      -- question_header = " " .. user .. " ",
      separator = "━━",
      headers = {
        user = "󱍋 User (" .. user .. ") ",
        assistant = " Better User ",
        tool = " Tool ",
      },
      mappings = {
        reset = {
          normal = "<C-l>",
          insert = "<C-l>",
          callback = function()
            vim.cmd("TmuxNavigateRight")
          end,
        },
      },
      -- Requires some fixes since we get the error:

      -- - ❌ ERROR Failed to run healthcheck for "blink.cmp" plugin. Exception:
      --   ...zy/blink.cmp/lua/blink/cmp/sources/lib/provider/init.lua:39: module 'blink-cmp-copilot' not found:
      --   	no field package.preload['blink-cmp-copilot']
      --   	cache_loader: module 'blink-cmp-copilot' not found
      --   	cache_loader_lib: module 'blink-cmp-copilot' not found
      --   	no file './blink-cmp-copilot.lua'
      --   	no file '/opt/homebrew/share/luajit-2.1/blink-cmp-copilot.lua'
      --   	no file '/usr/local/share/lua/5.1/blink-cmp-copilot.lua'
      --   	no file '/usr/local/share/lua/5.1/blink-cmp-copilot/init.lua'
      --   	no file '/opt/homebrew/share/lua/5.1/blink-cmp-copilot.lua'
      --   	no file '/opt/homebrew/share/lua/5.1/blink-cmp-copilot/init.lua'
      --   	no file './blink-cmp-copilot.so'
      --   	no file '/usr/local/lib/lua/5.1/blink-cmp-copilot.so'
      --   	no file '/opt/homebrew/lib/lua/5.1/blink-cmp-copilot.so'
      --   	no file '/usr/local/lib/lua/5.1/loadall.so'
      --   	no file '/Users/fcabrera/.local/share/nvim/lazy/blink.cmp/lua/blink/cmp/fuzzy/rust/../../../../../target/release/libblink-cmp-copilot.dylib'
      --   	no file '/Users/fcabrera/.local/share/nvim/lazy/blink.cmp/lua/blink/cmp/fuzzy/rust/../../../../../target/release/blink-cmp-copilot.dylib'
      --   	no file '/Users/fcabrera/.local/share/nvim/lazy/blink.cmp/lua/blink/cmp/fuzzy/rust/../../../../../target/release/libblink-cmp-copilot.dylib'
      --   	no file '/Users/fcabrera/.local/share/nvim/lazy/blink.cmp/lua/blink/cmp/fuzzy/rust/../../../../../target/release/blink-cmp-copilot.dylib'
      --   	no file '/Users/fcabrera/.local/share/nvim/lazy/CopilotChat.nvim/lua/CopilotChat/../../build/blink-cmp-copilot.dylib'

      -- providers = {
      --   ollama = {
      --     prepare_input = require("CopilotChat.config.providers").copilot.prepare_input,
      --     prepare_output = require("CopilotChat.config.providers").copilot.prepare_output,
      --
      --     get_models = function(headers)
      --       local response, err = require("CopilotChat.utils.curl").get("http://localhost:11434/v1/models", {
      --         headers = headers,
      --         json_response = true,
      --       })
      --
      --       if err then
      --         error(err)
      --       end
      --
      --       return vim.tbl_map(function(model)
      --         return {
      --           id = model.id,
      --           name = model.id,
      --         }
      --       end, response.body.data)
      --     end,
      --
      --     embed = function(inputs, headers)
      --       local response, err = require("CopilotChat.utils.curl").post("http://localhost:11434/v1/embeddings", {
      --         headers = headers,
      --         json_request = true,
      --         json_response = true,
      --         body = {
      --           input = inputs,
      --           model = "qwen2.5-coder:1.5b-base",
      --         },
      --       })
      --
      --       if err then
      --         error(err)
      --       end
      --
      --       return response.body.data
      --     end,
      --
      --     get_url = function()
      --       return "http://localhost:11434/v1/chat/completions"
      --     end,
      --   },
      -- },
    }
  end,
  keys = {
    {
      "<leader>aa",
      function()
        local copilot_chat = require("CopilotChat").chat
        local neotree_win = nil
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neo-tree" then
            neotree_win = win
            break
          end
        end

        -- If CopilotChat window is NOT visible, close the snacks picker (if any)
        if not copilot_chat:visible() and neotree_win then
          vim.cmd("Neotree close")
        end

        -- Always toggle CopilotChat after handling snacks picker logic
        return require("CopilotChat").toggle()
      end,
      desc = "Toggle (CopilotChat)",
      mode = { "n", "v" },
    },
    { "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "Select Models (CopilotChat)" },
    {
      "<C-c>",
      function()
        local chat = require("CopilotChat")
        return chat.stop()
      end,
      mode = { "n" },
      desc = "Stop (CopilotChat)",
    },
  },
}
