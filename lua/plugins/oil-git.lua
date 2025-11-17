-- return {
--   "benomahony/oil-git.nvim",
--   enabled = false,
--   dependencies = { "stevearc/oil.nvim" },
--   -- No opts or config needed! Works automatically
-- }
return {
  "refractalize/oil-git-status.nvim",

  dependencies = {
    "stevearc/oil.nvim",
  },

  config = true,
}
