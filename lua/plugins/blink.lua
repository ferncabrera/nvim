return {
  {
    "saghen/blink.cmp",
    dependencies = {
      -- {
      --   "milanglacier/minuet-ai.nvim",
      --   version = "*", -- use the latest stable version
      -- },
      "kristijanhusak/vim-dadbod-completion",
      "niuiic/blink-cmp-rg",
      "bydlw98/blink-cmp-env",
      { "marcoSven/blink-cmp-yanky" },
      "moyiz/blink-emoji.nvim",
      "mgalliou/blink-cmp-tmux",
      -- {
      --   "mikavilpas/blink-ripgrep.nvim",
      --   version = "*", -- use the latest stable version
      -- },
    },
    optional = true,
    opts = {
      keymap = {
        preset = "super-tab",
        ["<A-1>"] = {
          function(cmp)
            cmp.accept({ index = 1 })
          end,
        },
        ["<A-2>"] = {
          function(cmp)
            cmp.accept({ index = 2 })
          end,
        },
        ["<A-3>"] = {
          function(cmp)
            cmp.accept({ index = 3 })
          end,
        },
        ["<A-4>"] = {
          function(cmp)
            cmp.accept({ index = 4 })
          end,
        },
        ["<A-5>"] = {
          function(cmp)
            cmp.accept({ index = 5 })
          end,
        },
        ["<A-6>"] = {
          function(cmp)
            cmp.accept({ index = 6 })
          end,
        },
        ["<A-7>"] = {
          function(cmp)
            cmp.accept({ index = 7 })
          end,
        },
        ["<A-8>"] = {
          function(cmp)
            cmp.accept({ index = 8 })
          end,
        },
        ["<A-9>"] = {
          function(cmp)
            cmp.accept({ index = 9 })
          end,
        },
        ["<A-0>"] = {
          function(cmp)
            cmp.accept({ index = 10 })
          end,
        },
      },
      sources = {
        default = { "env", "ripgrep", "tmux", "yank", "emoji", inherit_defaults = true },
        per_filetype = {
          -- sql = { "dadbod", "copilot", inherit_defaults = true },
          sql = { "copilot", inherit_defaults = true },
          -- typescript = { "dadbod", "env", "ripgrep", "tmux", "yank", "emoji", inherit_defaults = true },
        },
        providers = {
          env = {
            name = "Env",
            module = "blink-cmp-env",
            opts = {
              item_kind = require("blink.cmp.types").CompletionItemKind.Variable,
              show_braces = false,
              show_documentation_window = true,
            },
          },
          dadbod = {
            name = "Dadbod",
            score_offset = 100, -- Tune by preference
            module = "vim_dadbod_completion.blink",
            enabled = true,
          },
          yank = {
            name = "yank",
            module = "blink-yanky",
            opts = {
              minLength = 5,
              onlyCurrentFiletype = true,
              trigger_characters = { '"' },
              kind_icon = "󰅍",
            },
          },
          tmux = {
            module = "blink-cmp-tmux",
            name = "tmux",
            -- default options
            opts = {
              all_panes = false,
              capture_history = false,
              -- only suggest completions from `tmux` if the `trigger_chars` are
              -- used
              -- triggered_only = false,
              -- trigger_chars = { "." },
            },
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = " "
                item.kind_name = "tmux"
              end
              return items
            end,
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 30, -- Tune by preference
            opts = {
              insert = true, -- Insert emoji (default) or complete its name
              ---@type string|table|fun():table
              trigger = function()
                return { ":" }
              end,
            },
            -- should_show_items = function()
            --   return vim.tbl_contains(
            --     -- Enable emoji completion only for git commits and markdown.
            --     -- By default, enabled for all file-types.
            --     { "gitcommit", "markdown" },
            --     vim.o.filetype
            --   )
            -- end,
          },
          ripgrep = {
            module = "blink-cmp-rg",
            name = "Ripgrep",
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = " "
                item.kind_name = "Ripgrep"
              end
              return items
            end,
            opts = {
              -- `min_keyword_length` only determines whether to show completion items in the menu,
              -- not whether to trigger a search. And we only has one chance to search.
              prefix_min_len = 3,
              get_command = function(context, prefix)
                return {
                  "rg",
                  "--no-config",
                  "--json",
                  "--word-regexp",
                  "--ignore-case",
                  "-g",
                  "*ockerfile*",
                  "-g",
                  "*compose*",
                  "-g",
                  "*env*",
                  "-g",
                  "*conf*",
                  "--",
                  prefix .. "[\\w_-]+",
                  vim.fs.root(0, ".git") or vim.fn.getcwd(),
                }
              end,
              get_prefix = function(context)
                return context.line:sub(1, context.cursor[2]):match("[%w_-]+$") or ""
              end,
            },
          },
          --     minuet = {
          --       name = "minuet",
          --       module = "minuet.blink",
          --       async = true,
          --       -- Should match minuet.config.request_timeout * 1000,
          --       -- since minuet.config.request_timeout is in seconds
          --       timeout_ms = 3000,
          --       score_offset = 99, -- Gives minuet higher priority among suggestions
          --       enabled = function()
          --         return vim.fn.system("pgrep ollama") ~= ""
          --       end,
          --       kind = "Minuet", -- 👈 Add an icon/label here
          --       transform_items = function(ctx, items)
          --         for _, item in ipairs(items) do
          --           item.kind_icon = "🦙" -- pick any icon (example: nf-oct-milestone)
          --           item.kind_name = "Minuet"
          --         end
          --         return items
          --       end,
          --     },
          -- ripgrep_2 = {
          --   module = "blink-ripgrep",
          --   name = "Ripgrep",
          --   opts = {
          --     backend = {
          --       use = "gitgrep-or-ripgrep",
          --       ripgrep = {
          --         ignore_paths = {
          --           -- "/Users/fcabrera/Code/open_ims/common/grafana/dashboards/*",
          --         },
          --       },
          --     },
          --   },
          -- },
        },
      },
      completion = {
        -- trigger = {
        --   show_in_snippet = false,
        -- },
        list = {
          selection = {
            preselect = function(ctx)
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
          },
        },
        menu = {
          draw = {
            columns = {
              { "item_idx" },
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name", gap = 1 },
            },
            components = {
              label_description = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.label_description
                end,
                highlight = "BlinkCmpLabel",
              },
              source_name = {
                width = { max = 30 },
                text = function(ctx)
                  return ctx.source_name
                end,
                highlight = "BlinkCmpLabel",
              },
              item_idx = {
                text = function(ctx)
                  return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
                end,
                highlight = "BlinkCmpItemIdx", -- optional, only if you want to change its color
              },
            },
          },
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
