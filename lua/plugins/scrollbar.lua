-- nvim-scrollbar v2: one floating bar per window. `vscode` everywhere (Git | search, marks, cursor | diagnostic
-- lanes, drawn over the thumb), a gvim-style solid two-column thumb for markdown. Click a mark to jump there, drag the
-- thumb ('mouse' is "a" in LazyVim). Coloured as v1 was: no track, so the window shows through around the thumb, and
-- the thumb takes the cursorline colour (ColorScheme handler in lua/config/autocmds.lua); marks keep the theme's
-- DiagnosticVirtualText*, GitSigns*, Search, Special and Comment (cursor dot) colours. Toggles: <leader>tB
-- scrollbar, <leader>tM overview minimap (hidden until asked for).

-- Floats are never sources (that needs `scrollbar.floats`), so pickers, previews, incline, blink, noice and notify
-- get no bar. These lists add to the plugin defaults for normal windows: `nofile` covers neo-tree, Trouble, the
-- dashboard and DBUI; `acwrite` is oil; the filetypes catch the rest.
local excluded_buftypes = { "nofile", "prompt", "quickfix", "help", "acwrite" } -- "terminal" is a default
local excluded_filetypes = {
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
  "neo-tree",
  "octo",
  "oil",
  "qf",
  "snacks_dashboard",
  "snacks_layout_box",
  "snacks_picker_list",
  "snacks_picker_preview",
  "snacks_terminal",
  "snacks_win",
  "trouble",
  "undotree",
}

-- A table keyed by name adds to the plugin defaults; a plain list would replace them
local function keyed(list)
  local set = {}
  for _, name in ipairs(list) do
    set[name] = true
  end
  return set
end

return {
  "petertriho/nvim-scrollbar",
  branch = "refactor/v2", -- v2 replaces v1 on main on 2026-11-16: then delete this line and :Lazy update
  event = "LazyFile",
  dependencies = { "lewis6991/gitsigns.nvim" }, -- hunk marks are ready for the first render
  opts = {
    exclude = { buftypes = keyed(excluded_buftypes), filetypes = keyed(excluded_filetypes) },
    -- cursor, diagnostic, search (native / and ?, no hlslens) and letter marks are on by default
    providers = { gitsigns = true },
    marks = {
      Cursor = { highlight = "Comment" }, -- position dot: subtler than Normal fg on a minimal UI
    },
    scrollbar = {
      preset = "vscode",
      -- The preset stacks every lane under the thumb, so the part of the file on screen never shows a mark (the
      -- cursor dot included) and the bar reads as gvim. Same three lanes with the marks on top, the way VS Code's
      -- see-through slider shows them, and no "track" layer: as with v1's bar, the cells around the thumb show the
      -- window below, so the cursorline and full-width backgrounds (render-markdown code blocks) run to the edge. A
      -- click on such a cell does nothing.
      layout = {
        columns = {
          { "thumb", { types = { "GitAdd", "GitChange", "GitDelete" } } },
          { "thumb", "marks" },
          { "thumb", { types = { "Error", "Warn", "Info", "Hint" } } },
        },
      },
      thumb = { blend = 0 }, -- solid (vscode's is see-through); the markdown profile inherits it and shares the groups
      unit = "screenline", -- thumb and marks follow wrapped lines and closed folds (profiles inherit it)
      overlap = {
        -- 0.12 has no 'wrapcolumn', so the default reservation leaves wrapped text under the bar. This pads the wrap
        -- points instead (experimental). Unwrapped windows, and a Neovim with 'wrapcolumn', behave as with `true`.
        reserve = "virtual_text",
        -- The empty cells show the window below unchanged; mark glyphs keep their colours (blend 1 rounds to none
        -- for text) and the thumb groups set blend = 0, so they stay solid.
        show_through = 1,
      },
      hide_if_all_visible = true, -- nothing at all when the whole buffer fits in the window
      profiles = {
        -- gvim's two solid thumb columns and no marks, without its track (as above)
        { match = { filetypes = { "markdown" } }, layout = { columns = { { "thumb" }, { "thumb" } } } },
      },
    },
    minimap = {
      enabled = true,
      show = false, -- hidden until <leader>tM
      visibility = "active", -- only in the current window
      preset = "overview", -- the whole buffer fitted into the float; click or drag it to move
      width = 15, -- cells (the preset's is 10); each covers 8 source columns, so the map reaches the colorcolumn (120)
    },
  },
  config = function(_, opts)
    require("scrollbar").setup(opts)

    -- `get` reads the master flag that :ScrollbarToggle / :MinimapToggle flip, so the state stays right
    Snacks.toggle({
      name = "scrollbar",
      get = function()
        return require("scrollbar.renderer").is_visible()
      end,
      set = function(state)
        require("scrollbar")[state and "show" or "hide"]()
      end,
    }):map("<leader>tB") -- personal group; see lua/plugins/which-key.lua
    Snacks.toggle({
      name = "minimap",
      get = function()
        return require("scrollbar.minimap.renderer").is_visible()
      end,
      set = function(state)
        require("scrollbar.minimap")[state and "show" or "hide"]()
      end,
    }):map("<leader>tM")
  end,
}
