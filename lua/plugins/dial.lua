-- Better increase/decrease. Extends the `editor.dial` extra (which owns <C-a>/<C-x>/g<C-a>/g<C-x>,
-- `vim.g.dials_by_ft` and the per-filetype groups) instead of replacing its `config`.
return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", false, mode = { "n", "v" } }, -- tmux prefix; key ids are per mode, so remove both
    {
      "<C-y>",
      function()
        local group = (vim.g.dials_by_ft or {})[vim.bo.filetype] or "default"
        return require("dial.map").inc_normal(group)
      end,
      expr = true,
      desc = "Increment",
    },
  },
  opts = function(_, opts)
    local augend = require("dial.augend")
    -- decimal, hex, %Y/%m/%d, bool and lua/python and/or are already in the extra's default group
    vim.list_extend(opts.groups.default, {
      augend.semver.alias.semver,
      augend.constant.new({ elements = { "let", "const" } }),
      augend.constant.new({ elements = { "yes", "no" } }),
      augend.constant.new({ elements = { "<", ">" } }),
    })
  end,
}
