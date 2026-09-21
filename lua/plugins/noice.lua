return {
  -- messages, cmdline and the popupmenu
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      table.insert(opts.routes, {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      })
      -- blink.cmp owns signature help (signature.enabled = true); noice's auto_open requested it a second time
      opts.lsp = opts.lsp or {}
      opts.lsp.signature = { auto_open = { enabled = false } }

      opts.commands = {
        all = {
          -- options for the message history that you get with `:Noice`
          view = "split",
          opts = { enter = true, format = "details" },
          filter = {},
        },
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(event)
          vim.schedule(function()
            require("noice.text.markdown").keys(event.buf)
          end)
        end,
      })

      opts.presets.lsp_doc_border = true
      opts.views = opts.views or {}
      opts.views.hover = { border = { style = vim.o.winborder } } -- "single", like native floats and snacks
    end,
  },
}
