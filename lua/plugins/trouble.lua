-- lua/plugins/trouble.lua
local function toggle_quickfix()
  local qf_open = false
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_open = true
      break
    end
  end
  if qf_open then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

return {
  {
    "folke/trouble.nvim",
    opts = {
      -- Place any other Trouble configuration options here.
    },
    keys = {
      -- Mapping for Trouble's quickfix view: now on <leader>xq
      {
        "<leader>xq",
        function()
          require("trouble").toggle("quickfix")
        end,
        desc = "Quickfix List (Trouble)",
      },
      -- Mapping for toggling the regular quickfix list on <leader>xQ.
      -- This mapping will close it if already open.
      {
        "<leader>xQ",
        toggle_quickfix,
        desc = "Quickfix List",
      },
    },
  },
}
