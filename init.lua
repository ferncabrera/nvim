-- Global variables.
MAP = vim.keymap.set
DEL = vim.keymap.del

local function detect_dark_mode()
  local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
  local result = handle:read("*a")
  handle:close()

  if string.find(result, "Dark") then
    return true -- Dark Mode is active
  else
    return false -- Light Mode is active (or AppleInterfaceStyle is not set)
  end
end

MODE = detect_dark_mode() and "dark" or "light"
THEME = "wave"

-- if vim.env.AUTO_NVIM_RESTORE == "1" then
--   vim.schedule(function()
--     require("persistence").load()
--   end)
-- end
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
