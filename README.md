# nvim

Personal [LazyVim](https://github.com/LazyVim/LazyVim) config for Neovim 0.12 on macOS (Ghostty + tmux),
tuned for TypeScript/Go/Python/Rust work alongside Claude Code.

- `lua/config/` — options, keymaps (`<leader>t` is the personal group), autocmds (single highlight
  handler), `kanagawa.lua` (dragon/lotus via `'background'`)
- `lua/plugins/` — LazyVim spec overrides; extras are enabled in `lazyvim.json`
- `lua/fern/` — small shared helpers
- `CLAUDE.md` — conventions and deliberate choices; `review.md` — the last full audit
