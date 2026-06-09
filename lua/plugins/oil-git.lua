return {
  "malewicz1337/oil-git.nvim",
  dependencies = { "stevearc/oil.nvim" },
  opts = {
    show_branch = false, -- Show current Git branch in oil buffers
    branch_format = "εéá %s", -- Format string for branch display
  },
  config = function(_, opts)
    local highlights = {
      OilGitAdded = { fg = "#6f894e" },
      OilGitModifiedStaged = { fg = "#4d699b" },
      OilGitModifiedUnstaged = { fg = "#89b4fa" },
      OilGitBranch = { fg = "#89b4fa" },
      OilGitRenamed = { fg = "#cba6f7" },
      OilGitDeleted = { fg = "#ff5d62" },
      OilGitCopied = { fg = "#cba6f7" },
      OilGitConflict = { fg = "#e82424" },
      OilGitUntracked = { fg = "#98bb2a" },
      OilGitIgnored = { fg = "#737c73" },
    }

    local function apply_hl()
      for name, val in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, val)
      end
    end

    -- Re-apply when colorscheme changes (overrides scheme-provided values)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("OilGitHighlights", { clear = true }),
      callback = apply_hl,
    })

    apply_hl() -- apply now (after current colorscheme)
    require("oil-git").setup(opts) -- setup AFTER hl exist so plugin won't touch them
  end,
}
