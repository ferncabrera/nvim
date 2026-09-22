-- Icons + labels for the custom keymaps. which-key reads `desc` from the real keymaps (set in
-- lua/config/keymaps.lua and the plugin specs); the entries below only attach an icon, so a key that
-- is renamed or removed there simply loses its icon instead of showing a phantom entry.
--
-- Glyphs are written as \u{XXXX} escapes: private-use-area characters are invisible in most diffs and
-- have been silently dropped by edits before. Colors: azure/blue/cyan/green/grey/orange/purple/red/yellow.
local icons = {
  ai = "\u{EE0D}", -- robot          Claude / agent actions
  copy = "\u{F0147}", -- clipboard      yank helpers
  diag = "\u{F15AB}", -- alert-circle   diagnostics
  diff = "\u{F0993}", -- file-compare   diffs
  git = "\u{F02A2}", -- git            hunks / review base
  worktree = "\u{E5FB}", -- git folder     worktrees
  file = "\u{F0214}", -- file           buffers / paths
  folder = "\u{E5FF}", -- folder         project root
  shell = "\u{E795}", -- terminal       chmod
  sub = "\u{F06D4}", -- find-replace   :s helpers
  db = "\u{F01BC}", -- database       dadbod
  crumbs = "\u{EAB6}", -- chevron-right  navic breadcrumbs
  ui = "\u{F0675}", -- palette        statusline
  scroll = "\u{F1550}", -- scroll-wheel   scrollbar
  scrollup = "\u{F1551}", -- scroll-wheel   EOF clamp
  undo = "\u{F021}", -- rotate         undotree
  code = "\u{F121}", -- code           semantic tokens
  ts = "\u{F06E6}", -- typescript     tsc
  save = "\u{F0C7}", -- save           :w
  window = "\u{EB7F}", -- window         resize
  env = "\u{F0214}", -- file           ecolog
  misc = "\u{F01D8}", -- dots           the group itself
}

--- `{ "<lhs>", icon = { icon = ..., color = ... } }`, optionally for extra modes
local function ico(lhs, icon, color, mode)
  return { lhs, icon = { icon = icon, color = color }, mode = mode }
end

return {
  "folke/which-key.nvim",
  opts = {
    -- Wait longer before the popup appears (upstream default is 200ms).
    -- Plugin popups (registers on `"`, marks on `'`, spelling on `z=`) stay
    -- instant, mirroring which-key's own default function.
    delay = function(ctx)
      return ctx.plugin and 0 or 1000
    end,
    win = { border = vim.o.winborder }, -- match native floats / snacks ("single") instead of helix's rounded
    spec = {
      { "<leader>t", group = "custom/primagen", mode = { "n", "v" }, icon = { icon = icons.misc, color = "azure" } },

      -- Claude / agents ---------------------------------------------------
      ico("<leader>ta", icons.ai, "green", { "n", "x" }), -- send @file (+ range in visual)
      ico("<leader>tA", icons.ai, "green", { "n", "x" }), -- send buffer / selection
      ico("<leader>tq", icons.diag, "green"), -- diagnostics -> quickfix (Trouble)
      ico("<leader>tQ", icons.copy, "green"), -- diagnostics -> clipboard
      ico("<leader>ck", icons.ts, "blue"), -- typecheck project (tsc)

      -- Git / diff review -------------------------------------------------
      ico("<leader>tb", icons.git, "orange"), -- hunks vs main (review base)
      ico("<leader>td", icons.diff, "orange"), -- diffthis in all windows
      ico("<leader>tv", icons.diff, "orange"), -- diffview: working tree
      ico("<leader>tV", icons.diff, "orange"), -- diffview: branch vs main
      ico("<leader>th", icons.diff, "orange"), -- diffview: file history
      ico("<leader>tH", icons.diff, "orange"), -- diffview: repo history
      ico("<leader>gw", icons.worktree, "orange"), -- worktrees (Claude sessions)

      -- Paths / files -----------------------------------------------------
      ico("<leader>tc", icons.copy, "yellow"), -- copy file name
      ico("<leader>tf", icons.copy, "yellow"), -- copy full path
      ico("<leader>tp", icons.copy, "yellow"), -- copy relative path
      ico("<leader>to", icons.file, "cyan"), -- open path from clipboard
      ico("<leader>t.", icons.folder, "cyan"), -- cd to project root
      ico("<leader>tx", icons.shell, "red"), -- chmod +x

      -- Editing -----------------------------------------------------------
      ico("<leader>ts", icons.sub, "blue"), -- substitute word in file
      ico("<leader>tS", icons.sub, "blue"), -- substitute word (confirm)

      -- Database ------------------------------------------------------------
      ico("<leader>tD", icons.db, "purple"), -- connect from env
      ico("<leader>D", icons.db, "purple"), -- DBUI

      -- UI toggles ----------------------------------------------------------
      ico("<leader>tg", icons.git, "yellow"), -- incline git diff
      ico("<leader>ti", icons.diag, "yellow"), -- incline diagnostics
      ico("<leader>tm", icons.crumbs, "yellow"), -- incline breadcrumbs
      ico("<leader>tt", icons.ui, "yellow"), -- statusline
      ico("<leader>tB", icons.scroll, "yellow"), -- scrollbar
      ico("<leader>tu", icons.undo, "purple"), -- undotree
      ico("<leader>uH", icons.code, "yellow"), -- semantic tokens
      ico("<leader>uo", icons.scrollup, "yellow"), -- clamp scroll at EOF

      -- Windows / files -----------------------------------------------------
      ico("<leader>ww", icons.save, "green"), -- :w
      ico("<leader>w>", icons.window, "blue"),
      ico("<leader>w<", icons.window, "blue"),
      ico("<leader>w+", icons.window, "blue"),
      ico("<leader>w-", icons.window, "blue"),
      ico("<leader>bh", icons.file, "cyan"), -- close hidden buffers
      ico("<leader>bn", icons.file, "cyan"), -- close nameless buffers

      -- ecolog ---------------------------------------------------------------
      -- ecolog.lua registers the keys; name the group here so the icon does not replace its label
      { "<leader>e", group = "ecolog", icon = { icon = icons.env, color = "green" }, mode = { "n", "v" } },
    },
  },
}
