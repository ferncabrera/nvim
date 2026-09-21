-- File-list driven review of what an agent (or you) changed: working tree, whole branch vs main,
-- file history, 3-way merge tool. <leader>td (windo diffthis) stays for ad-hoc window diffs.
local function view_open()
  local ok, lib = pcall(require, "diffview.lib")
  return ok and lib.get_current_view() ~= nil
end

-- toggle: close the diffview in the current tab, otherwise open one with `args` (string or function)
local function toggle(args)
  return function()
    if view_open() then
      return vim.cmd("DiffviewClose")
    end
    local a = type(args) == "function" and args() or args
    if a == false then
      return
    end
    vim.cmd("DiffviewOpen " .. (a or ""))
  end
end

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  opts = { enhanced_diff_hl = true, view = { merge_tool = { layout = "diff3_mixed" } } },
  keys = {
    { "<leader>tv", toggle(), desc = "Diffview: working tree (toggle)" },
    {
      "<leader>tV",
      toggle(function()
        local sha, base = require("fern.git").merge_base()
        if not sha then
          vim.notify("diffview: no default branch / merge-base found", vim.log.levels.WARN)
          return false
        end
        vim.notify(("diffview: branch + working tree vs merge-base(%s)"):format(base))
        return sha
      end),
      desc = "Diffview: branch vs main (toggle)",
    },
    { "<leader>th", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
    { "<leader>tH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: repo history" },
  },
}
