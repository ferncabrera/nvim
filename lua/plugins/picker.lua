-- Show all files for explorer, but ignore specific folders for all other file searches
return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      enabled = false,
      replace_netrw = false, -- Replace netrw with the snacks explorer
    },
    picker = {
      layout = {
        reverse = true,
        layout = {
          box = "horizontal",
          backdrop = false,
          width = 0.8,
          height = 0.9,
          border = "none",
          {
            box = "vertical",
            { win = "list", title = " Results ", title_pos = "center", border = true },
            { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
          },
          {
            win = "preview",
            title = "{preview:Preview}",
            width = 0.45,
            border = true,
            title_pos = "center",
          },
        },
      },

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
  keys = {
    { "<leader>fe", false },
    { "<leader>fE", false },
    { "<leader>E", false },
    { "<leader>e", false },
  },
}
