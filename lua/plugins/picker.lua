-- Show all files for explorer, but ignore specific folders for all other file searches
return {
  "folke/snacks.nvim",
  opts = {
    styles = {
      zen = {
        keys = { q = "close" },
        width = 180,
      },
    },
    zen = {
      toggles = {
        dim = false,
        git_signs = true,
        mini_diff_signs = false,
        diagnostics = true,
        inlay_hints = false,
      },
    },
    explorer = {
      enabled = false,
      replace_netrw = false, -- Replace netrw with the snacks explorer
    },
    picker = {
      win = {
        -- input window
        input = {
          keys = {
            -- to close the picker on ESC instead of going to normal mode,
            -- add the following keymap to your config
            -- ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<c-t>"] = {
              "trouble_open",
              mode = { "n", "i" },
            },
            ["<a-a>"] = { "select_all", mode = { "n", "i" } },
            ["K"] = "preview_scroll_up",
            ["J"] = "preview_scroll_down",
          },
        },
      },
      -- layout = {
      --   reverse = true,
      --   layout = {
      --     box = "horizontal",
      --     backdrop = false,
      --     width = 0.8,
      --     height = 0.9,
      --     border = "none",
      --     {
      --       box = "vertical",
      --       { win = "list", title = " Results ", title_pos = "center", border = true },
      --       { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
      --     },
      --     {
      --       win = "preview",
      --       title = "{preview:Preview}",
      --       width = 0.45,
      --       border = true,
      --       title_pos = "center",
      --     },
      --   },
      -- },

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
    -- {
    --   "<leader>n",
    --   function()
    --     vim.cmd("Noice fzf")
    --   end,
    --   desc = "Notification History",
    -- },
    { "<leader>fe", false },
    { "<leader>fE", false },
    { "<leader>E", false },
    { "<leader>e", false },
  },
}
