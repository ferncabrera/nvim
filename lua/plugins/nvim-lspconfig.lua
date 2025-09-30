return {
  "neovim/nvim-lspconfig",
  opts = {
    --   servers = {
    --     postgres_lsp = {
    --       -- cmd = { "postgrestools", "lsp-proxy" },
    --       -- filetypes = { "sql" },
    --       -- root_dir = require("lspconfig.util").root_pattern("postgrestools.jsonc"),
    --     },
    --   },
    inlay_hints = { enabled = false },
    diagnostics = {
      virtual_text = false, -- disable virtual text diagnostics
      underline = true, -- enable underline for diagnostics
      signs = true, -- enable signs for diagnostics
      update_in_insert = true, -- do not update diagnostics in insert mode
    },
  },
}
