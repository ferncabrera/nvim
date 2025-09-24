-- Global variables.
MAP = vim.keymap.set
DEL = vim.keymap.del
if vim.env.AUTO_NVIM_RESTORE == "1" then
  vim.schedule(function()
    require("persistence").load()
  end)
end
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
