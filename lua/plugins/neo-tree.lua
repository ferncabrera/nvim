-- Overrides only: cmd/keys/init/opts come from LazyVim's editor.neo-tree extra (vim.g.lazyvim_explorer).
return {
  "nvim-neo-tree/neo-tree.nvim",
  -- ecolog owns <leader>e as its which-key group; the explorer lives on <leader>fe / <leader>fE
  keys = { { "<leader>e", false }, { "<leader>E", false } },
  opts = {
    filesystem = {
      hijack_netrw_behavior = "disabled", -- oil owns `nvim <dir>`; drop this line if you want neo-tree for it
      filtered_items = { -- neo-tree hides dotfiles + gitignored by default; oil shows them, so the two disagreed
        always_show = { ".claude", "settings.local.json", ".github", ".env", ".mcp.json" },
        always_show_by_pattern = { ".env.*" },
        never_show = { ".DS_Store" },
      },
    },
    window = {
      mappings = {
        ["P"] = false,
        ["<C-p>"] = {
          "toggle_preview",
          config = { use_float = false, use_snacks_image = true, use_image_nvim = true },
        },
      },
    },
  },
}
