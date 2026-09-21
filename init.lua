-- Global variables.
MAP = vim.keymap.set
DEL = vim.keymap.del

-- macOS appearance at startup. Reading the plist directly costs 0.03 ms; the previous
-- io.popen("defaults read ...") forked a shell + the defaults CLI for ~8 ms on every launch.
local function detect_dark_mode()
  local f = io.open(vim.env.HOME .. "/Library/Preferences/.GlobalPreferences.plist", "rb")
  if not f then
    return false -- same fallback as before: light mode
  end
  local data = f:read("*a")
  f:close()
  if data:sub(1, 6) ~= "bplist" then
    -- not a binary plist (never the case today): fall back to the slow CLI rather than forcing light mode
    local p = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    local out = p and p:read("*a") or ""
    if p then
      p:close()
    end
    return out:find("Dark") ~= nil
  end
  -- the key only exists while Dark Mode is on. "\19" is the bplist length byte for the 19-char key, so
  -- this cannot false-match "AppleInterfaceStyleSwitchesAutomatically" (length byte 0x28).
  return data:find("\19AppleInterfaceStyle", 1, true) ~= nil
end

vim.o.background = detect_dark_mode() and "dark" or "light"
MODE = vim.o.background
THEME = (MODE == "light") and "lotus" or "dragon"

-- if vim.env.AUTO_NVIM_RESTORE == "1" then
--   vim.schedule(function()
--     require("persistence").load()
--   end)
-- end
-- bootstrap lazy.nvim, LazyVim and your plugins

require("config.lazy")
