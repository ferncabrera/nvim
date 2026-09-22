-- Scrollbar with cursor / diagnostic / git-hunk marks, only in windows that show a real file.
-- Colours are derived from theme highlight groups (CursorLine, DiagnosticVirtualText*, GitSigns*) on
-- every ColorScheme, so they follow dragon/lotus without extra config. Toggle: <leader>uB.

-- Special buffers never get a bar. `nofile` covers pickers, previews, incline, blink, noice, notify,
-- dashboard and Trouble; `acwrite` is oil; the filetype list catches the rest (and the plugin defaults).
local excluded_buftypes = { "nofile", "prompt", "terminal", "quickfix", "help", "acwrite" }
local excluded_filetypes = {
  -- plugin defaults
  "blink-cmp-menu",
  "dropbar_menu",
  "dropbar_menu_fzf",
  "DressingInput",
  "cmp_docs",
  "cmp_menu",
  "noice",
  "prompt",
  "TelescopePrompt",
  -- this config
  "blink-cmp-documentation",
  "blink-cmp-signature",
  "checkhealth",
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "dbout",
  "dbui",
  "diff",
  "DiffviewFileHistory",
  "DiffviewFiles",
  "gitsigns-blame",
  "grug-far",
  "help",
  "incline",
  "lazy",
  "lspinfo",
  "mason",
  "neo-tree",
  "neo-tree-popup",
  "notify",
  "octo",
  "oil",
  "qf",
  "snacks_dashboard",
  "snacks_input",
  "snacks_layout_box",
  "snacks_notif",
  "snacks_notif_history",
  "snacks_picker_input",
  "snacks_picker_list",
  "snacks_picker_preview",
  "snacks_terminal",
  "snacks_win",
  "trouble",
  "undotree",
}

return {
  "petertriho/nvim-scrollbar",
  event = "LazyFile",
  opts = {
    hide_if_all_visible = true, -- nothing at all when the whole buffer fits in the window
    excluded_buftypes = excluded_buftypes,
    excluded_filetypes = excluded_filetypes,
    handlers = {
      cursor = true,
      diagnostic = true,
      gitsigns = true, -- hunk marks; gitsigns is lazy-loaded by the require inside the handler
      handle = true,
      search = false, -- needs nvim-hlslens
    },
    marks = {
      Cursor = { highlight = "Comment" }, -- position dot: subtler than Normal fg on a minimal UI
    },
  },
  config = function(_, opts)
    local sb = require("scrollbar")

    -- The plugin renders into whatever window triggered the autocmd, floats included (hover docs,
    -- picker previews, tiny-code-action). Skip every floating window before it draws.
    local render = sb.render
    sb.render = function()
      if vim.api.nvim_win_get_config(0).relative ~= "" then
        return sb.clear()
      end
      return render()
    end

    sb.setup(opts)

    Snacks.toggle({
      name = "scrollbar",
      get = function()
        return require("scrollbar.config").get().show
      end,
      set = function(state)
        require("scrollbar.utils")[state and "show" or "hide"]()
      end,
    }):map("<leader>tB") -- personal group; see lua/plugins/which-key.lua
  end,
}
