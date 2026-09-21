-- Code actions with a live diff preview (delta) instead of a blind vim.ui.select list.
return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = { "folke/snacks.nvim" },
    event = "LspAttach",
    opts = {
      backend = "delta", -- switch to "vim" if big refactors feel slow
      picker = { "snacks", opts = { layout = "vscode" } },
      backend_opts = { delta = { header_lines_to_remove = 4, args = { "--line-numbers" } } },
    },
  },
  {
    -- override LazyVim's key through the LSP key spec (opts_extend "servers.*.keys": later lhs wins)
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "<leader>ca",
              function()
                require("tiny-code-action").code_action()
              end,
              desc = "Code Action (preview)",
              mode = { "n", "x" },
              has = "codeAction",
            },
          },
        },
      },
    },
  },
}
