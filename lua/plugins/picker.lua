-- Show all files for explorer, but ignore specific folders for all other file searches
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = true,
          exclude = {
            "node_modules",
            "dist",
            ".git",
            ".yarn",
            ".venv",
            "__pycache__",
          },
        },
        explorer = {
          ignored = false,
          hidden = true,
          exclude = {},
        },
      },
      hidden = true,
      ignored = true,
      exclude = {
        "node_modules",
        "dist",
        ".git",
        ".yarn",
        ".venv",
        "__pycache__",
      },
    },
  },
}
