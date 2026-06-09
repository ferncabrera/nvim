return {
  "JezerM/oil-lsp-diagnostics.nvim",
  dependencies = { "stevearc/oil.nvim" },
  opts = {},
  config = function(_, opts)
    -- Pre-mark non-local oil buffers (oil-ssh://, oil-trash://) so the
    -- plugin's FileType autocmd skips them. Avoids nil-dir concat error.
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function(args)
        local name = vim.api.nvim_buf_get_name(args.buf)
        if not name:match("^oil:///") and not vim.startswith(name, "/") then
          vim.b[args.buf].oil_lsp_started = true
        end
      end,
    })
    require("oil-lsp-diagnostics").setup(opts or {})
  end,
}
