-- snacks: picker/zen/dashboard overrides (the explorer is neo-tree via vim.g.lazyvim_explorer)
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
    picker = {
      formatters = { file = { filename_first = true, truncate = "left" } }, -- basename left, dimmed dir right
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
      -- hidden/ignored/exclude are set per source on purpose: at the top level of `picker` snacks merges
      -- them into every source, so grep ran rg with --no-ignore and returned coverage HTML, Claude
      -- worktrees and gitignored Playwright .auth/*.json session state.
      sources = {
        files = {
          matcher = { frecency = true, sort_empty = true }, -- recently/frequently opened files first
          hidden = true,
          ignored = true, -- deliberate: gitignored files stay findable; <a-i> toggles it per picker
          exclude = {
            "node_modules",
            "dist",
            ".git",
            ".yarn",
            ".venv",
            "__pycache__",
            ".claude/worktrees",
            "coverage",
            "coverage-site",
            "**/.auth",
          },
        },
        grep = { hidden = true, ignored = false },
        grep_word = { hidden = true, ignored = false },
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
    { "<leader>fF", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
    { "<leader><space>", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
    { "<leader>ff", LazyVim.pick("files", { root = false }), desc = "Find Files (cwd)" },
  },
}
