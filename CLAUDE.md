# Neovim config (LazyVim)

Personal LazyVim 16 config on Neovim 0.12, macOS + Ghostty + tmux. `review.md` is the last full audit.

## Conventions

- Extend LazyVim specs with `opts = function(_, opts)` or an `opts` table. Never use `config = function()`
  unless it calls `require(<plugin>).setup(opts)` — a bare `config` replaces lazy.nvim's setup and silently
  drops `opts` (this bit `dial.lua` and `flash.lua` before).
- Enable extras in `lazyvim.json` (`:LazyExtras`) instead of copying an extra's spec into `lua/plugins/`.
  Override only what differs (see `neo-tree.lua`, `dial.lua`).
- `lua/config/options.lua` runs before lazy.nvim: no `require` of plugins, no `vim.lsp.enable()` there.
  LSP servers go in `lua/plugins/nvim-lspconfig.lua` `opts.servers` (Mason installs them).
- `lua/config/autocmds.lua` owns the custom highlight groups (single `ColorScheme` handler driven by
  kanagawa's palette); do not hardcode colours per light/dark elsewhere. `'background'` is the theme switch
  (`dragon` dark / `lotus` light).
- `lua/fern/` holds small shared helpers (`git.lua`, `scroll.lua` = no scrolling past EOF, `discipline.lua`).
- Run `stylua lua init.lua` (Mason's stylua, `stylua.toml`: 2 spaces, width 120) before committing.
- No credentials in Lua. Env values come from ecolog (`<leader>e` group); secrets stay masked in completion.

## Deliberate choices (do not "fix")

- Minimal custom statusline (`options.lua`) + incline per window; lualine stays disabled.
- `relativenumber` off, inlay hints off, diagnostics `virtual_text` off (tiny-inline-diagnostic shows the
  cursor line), `q` disabled / `Q` records macros, `jj`/`jk` escape.
- blink: `<Tab>` = `select_and_accept` (super-tab preset), `<A-1..0>` accept by index, borderless menu,
  heavy source list gated by filetype/context rather than removed.
- Explorers: neo-tree (`<leader>fe`) and oil (`-`, owns `nvim <dir>`); `<leader>e` belongs to ecolog.
- `<leader>t` is the personal group: paths (`tc/tf/tp`), diff (`td`, diffview `tv/tV/th/tH`, gitsigns base
  `tb`), Claude popup (`ta/tA`), toggles (`tg/ti/tm/tt`), `tu` undotree, `tD` db.
- Claude Code runs in a tmux popup session (`claude-<path slug>`), not in an nvim terminal; no
  claudecode.nvim.
