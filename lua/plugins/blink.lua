return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        ["<A-y>"] = {
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
        preset = "super-tab",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "copilot", "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            async = true,
            -- Should match minuet.config.request_timeout * 1000,
            -- since minuet.config.request_timeout is in seconds
            timeout_ms = 3000,
            score_offset = 99, -- Gives minuet higher priority among suggestions
            enabled = function()
              return vim.fn.system("pgrep ollama") ~= ""
            end,
            kind = "Minuet", -- 👈 Add an icon/label here
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = "🦙" -- pick any icon (example: nf-oct-milestone)
                item.kind_name = "Minuet"
              end
              return items
            end,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            kind = "Copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
      completion = {
        list = {
          selection = {
            preselect = function(ctx)
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
          },
        },
        menu = {
          border = "rounded",
          -- winblend = vim.o.pumblend,
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      signature = {
        enabled = true,
        window = { winblend = vim.o.pumblend },
      },
    },
  },
}
