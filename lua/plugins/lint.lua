return {
  "mfussenegger/nvim-lint",
  opts = function(_, opts)
    -- eugene (Mason): Postgres migration lock-safety linter, only on migration files, never on dadbod query buffers
    opts.linters_by_ft.sql = vim.list_extend(opts.linters_by_ft.sql or {}, { "eugene" })
    opts.linters.eugene = {
      condition = function(ctx)
        return ctx.filename:match("/migrations?/") ~= nil
      end,
    }
  end,
}
