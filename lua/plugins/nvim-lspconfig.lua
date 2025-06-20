return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    diagnostics = {
      virtual_text = false, -- disable virtual text diagnostics
      underline = true, -- enable underline for diagnostics
      signs = true, -- enable signs for diagnostics
      update_in_insert = false, -- do not update diagnostics in insert mode
    },
  },
}
