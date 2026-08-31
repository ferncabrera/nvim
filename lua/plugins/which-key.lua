return {
  "folke/which-key.nvim",
  opts = {
    -- Wait longer before the popup appears (upstream default is 200ms).
    -- Plugin popups (registers on `"`, marks on `'`, spelling on `z=`) stay
    -- instant, mirroring which-key's own default function.
    delay = function(ctx)
      return ctx.plugin and 0 or 1000
    end,
  },
}
