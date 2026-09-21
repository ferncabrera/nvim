local prose_ft =
  { markdown = true, text = true, gitcommit = true, octo = true, help = true, NeogitCommitMessage = true }
local tmux_ft = { markdown = true, text = true, gitcommit = true, sh = true, bash = true, zsh = true, nu = true }

-- true in prose filetypes, or inside a comment/string node in code. Used as a provider `enabled`
-- function: blink evaluates it on the main loop *before* querying the source (guarded against fast
-- events), so gated sources do no work at all in code. `should_show_items` would run after the fetch.
local function in_prose()
  if prose_ft[vim.bo.filetype] then
    return true
  end
  -- blink calls this in insert mode, where the cursor sits one column past the typed text and a node
  -- lookup there returns the root node (chunk/program); look at the character before the cursor instead
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local ok, node = pcall(vim.treesitter.get_node, { pos = { row - 1, math.max(col - 1, 0) } })
  if not ok or not node then
    return false
  end
  local t = node:type()
  return t:find("comment", 1, true) ~= nil or t:find("string", 1, true) ~= nil
end

local function kind(icon, name)
  return function(_, items)
    for _, item in ipairs(items) do
      item.kind_icon = icon
      item.kind_name = name
    end
    return items
  end
end

local keymap = {
  preset = "super-tab",
  -- `cancel` also reverts the auto_insert preview of a navigated item; `hide` left that text behind
  ["<C-e>"] = { "cancel", "fallback" },
  ["<Tab>"] = {
    function(cmp)
      if cmp.snippet_active() then
        return cmp.accept()
      end
      return cmp.select_and_accept()
    end,
    -- LazyVim only injects these when <Tab> is not user-defined; required for ai.copilot-native / sidekick NES
    LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
    "fallback",
  },
  ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
  ["<C-k>"] = { "select_prev", "fallback" },
  ["<C-j>"] = { "select_next", "fallback" },
  ["<A-k>"] = { "show_signature", "hide_signature", "fallback" },
  -- <C-space>, <Up>/<Down>, <C-p>/<C-n>, <C-b>/<C-f> are the super-tab preset defaults; not restated
}
for i = 1, 10 do
  keymap[("<A-%d>"):format(i % 10)] = {
    function(cmp)
      cmp.accept({ index = i })
    end,
  }
end

return {
  {
    "saghen/blink.cmp",
    -- 1.x release tags (>= 1.0.0 < 2.0.0): prebuilt fuzzy binary, no cargo, no surprise jump to v2
    version = "1.*",
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
      "niuiic/blink-cmp-rg",
      "xieyonn/blink-cmp-dat-word",
      "marcoSven/blink-cmp-yanky",
      "moyiz/blink-emoji.nvim",
      "mgalliou/blink-cmp-tmux",
      "ph1losof/ecolog.nvim",
    },
    optional = true,
    opts = {
      keymap = keymap,
      fuzzy = {
        -- a fully typed identifier always beats boosted sources (copilot/dadbod/ecolog/emoji offsets)
        sorts = { "exact", "score", "sort_text" },
      },
      sources = {
        -- appended to LazyVim's lsp/path/snippets/buffer/copilot/dadbod (opts_extend); `inherit_defaults`
        -- is only meaningful in per_filetype and was dropped by the list merge anyway
        default = { "ecolog", "ripgrep", "tmux", "yank", "datword", "emoji" },
        providers = {
          -- name/module/enabled come from LazyVim's lang.sql extra (self-gated to sql/mysql/plsql).
          -- The previous `enabled = true` overrode that gate and made dadbod run in every buffer.
          dadbod = { score_offset = 100 },
          ecolog = {
            score_offset = 99,
            name = "ecolog",
            module = "ecolog.integrations.cmp.blink_cmp",
          },
          buffer = { min_keyword_length = 3 }, -- stop 1-2 char noise from big buffers
          -- DELETE this block if you switch to ai.copilot-native (the provider no longer exists)
          copilot = {
            score_offset = 50, -- above buffer/snippets, below an exact LSP hit; 100 always won
            opts = { max_completions = 1, max_attempts = 2 },
          },
          ripgrep = {
            module = "blink-cmp-rg",
            name = "Ripgrep",
            score_offset = -10,
            async = true, -- LSP items paint immediately; rg items merge in when the process finishes
            min_keyword_length = 3,
            transform_items = kind(" ", "Ripgrep"),
            opts = {
              -- searched once per new word (is_incomplete_forward = false), then cached for that word
              prefix_min_len = 3,
              get_command = function(_, prefix)
                return {
                  "rg",
                  "--json",
                  "--word-regexp",
                  "--ignore-case",
                  "--max-filesize",
                  "16K",
                  "-g",
                  "*ockerfile",
                  "-g",
                  "*compose*",
                  "-g",
                  "package.json",
                  "-g",
                  "*[Rr][Ee][Aa][Dd][Mm][Ee]*",
                  "-g",
                  "*-tags.json",
                  "-g",
                  ".gitignore",
                  "-g",
                  "[Mm]akefile",
                  "-g",
                  "*.sh",
                  "-g",
                  "*conf*",
                  -- negative globs last (rg: last matching glob wins). The old `*env*` glob overrode
                  -- .gitignore and completed raw words out of .secrets.env; ecolog owns env names.
                  "-g",
                  "!*secret*",
                  "-g",
                  "!.env*",
                  "-g",
                  "!*.env",
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
          tmux = {
            module = "blink-cmp-tmux",
            name = "tmux",
            score_offset = -50,
            -- async stops it holding the LSP menu; the plugin's own vim.system():wait() still blocks the UI
            -- thread, which is why it is gated to buffers where terminal words are useful.
            async = true,
            -- a user `enabled` replaces the plugin's own TMUX check, so re-add it
            enabled = function()
              return vim.env.TMUX ~= nil and tmux_ft[vim.bo.filetype] == true
            end,
            opts = {
              panes = "window", -- the real option name (`all_panes` was silently ignored)
              capture_history = false,
              trigger_chars = {}, -- the default "." was registered as a global completion trigger
            },
            transform_items = kind(" ", "tmux"),
          },
          yank = {
            name = "yank",
            module = "blink-yanky",
            score_offset = -75,
            min_keyword_length = 2,
            opts = {
              minLength = 5,
              onlyCurrentFiletype = true,
              -- deliberate: opening a string shows yank history. It is a global trigger char in every
              -- filetype; set `trigger_characters = {}` if you would rather reach it via <C-space>.
              trigger_characters = { '"' },
              kind_icon = "󰅍",
            },
          },
          datword = {
            name = "Dictionary",
            module = "blink-cmp-dat-word",
            score_offset = -100,
            enabled = in_prose, -- prose filetypes, comments and strings only
            min_keyword_length = 3, -- the plugin reads this from the provider config and skips the lookup below it
            max_items = 5,
            opts = { paths = { "/usr/share/dict/words" } },
          },
          emoji = {
            module = "blink-emoji",
            name = "Emoji",
            score_offset = 30,
            -- `enabled` (not should_show_items) also removes ":" from the global trigger list in code
            enabled = function()
              return prose_ft[vim.bo.filetype] == true
            end,
            opts = { insert = true },
          },
        },
      },
      completion = {
        -- optional, try for a week: match and replace the whole word around the cursor (`useSt|ate` + accept
        -- `useState` -> `useState`, not `useStateate`). Trade-off: the suffix becomes part of the query.
        -- keyword = { range = "full" },
        accept = {
          -- default 100 ms: vtsls only attaches the auto-import edit during completionItem/resolve; on timeout
          -- blink inserts the bare symbol without its import. Accept can wait up to this long when vtsls is
          -- slow; lower to 300 or drop if you never see missing imports
          resolve_timeout_ms = 500,
        },
        list = {
          selection = {
            preselect = function()
              return not require("blink.cmp").snippet_active({ direction = 1 })
            end,
          },
        },
        menu = {
          direction_priority = function()
            local ctx = require("blink.cmp").get_context()
            local item = require("blink.cmp").get_selected_item()
            if ctx == nil or item == nil then
              return { "s", "n" }
            end
            local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
            local is_multi_line = item_text:find("\n") ~= nil
            -- keep the menu upwards until it is re-opened
            if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
              vim.g.blink_cmp_upwards_ctx_id = ctx.id
              return { "n", "s" }
            end
            return { "s", "n" }
          end,
          draw = {
            -- treesitter = { "lsp" } is already set by LazyVim
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
                highlight = "BlinkCmpItemIdx",
              },
            },
          },
          border = "none", -- deliberate look with the Pmenu overrides in config/kanagawa.lua
          winblend = vim.o.pumblend,
        },
        documentation = { window = { border = "none" } },
      },
      signature = {
        enabled = true, -- noice's auto_open is turned off in noice.lua so this is requested once
        window = { winblend = vim.o.pumblend },
      },
      cmdline = {
        -- keep the "match insert mode" preset, but give <Up>/<Down> back to command history
        keymap = { preset = "inherit", ["<Up>"] = false, ["<Down>"] = false },
        completion = {
          menu = {
            auto_show = function()
              return vim.fn.getcmdtype() == ":" -- not during / and ? searches
            end,
          },
        },
      },
    },
  },
}
