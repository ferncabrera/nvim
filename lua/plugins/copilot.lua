-- Keep Copilot off buffers whose content must never leave the machine. Deep-merged with the
-- ai.copilot extra's filetypes (markdown/help = true); blink-copilot uses the same client.
return {
  "zbirenbaum/copilot.lua",
  opts = {
    filetypes = {
      env = false, -- .env, .env.*, *.env on nvim 0.12
      dotenv = false,
      sh = function() -- .envrc and env files that end up as sh
        return not vim.fs.basename(vim.api.nvim_buf_get_name(0)):match("^%.env")
      end,
      markdown = function() -- Claude Code prompt files (Ctrl+G / /memory)
        return not vim.api.nvim_buf_get_name(0):match("claude%-prompt%-")
      end,
    },
  },
}
