-- Show all files for explorer, but ignore specific folders for all other file searches
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- dev = { "~/dev", "~/Code" },
      projects = {
        "~/Code/open_ims/microservices/ims/client",
        "~/Code/open_ims/microservices/ims/server",
        "~/Code/open_ims/microservices/ims/migration-job",
        "~/Code/open_ims/microservices/ims/shared",
      },
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
