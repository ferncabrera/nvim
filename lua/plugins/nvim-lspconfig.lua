return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Postgres: mason installs `postgres-language-server`; the config has workspace_required = true and
      -- root marker `postgres-language-server.jsonc`, so it only attaches in repos containing that file.
      -- (Replaces vim.lsp.enable("postgres_lsp") in options.lua, which ran before lazy.nvim and logged
      -- "not executable" on every SQL buffer because the binary was never installed.)
      postgres_lsp = {},
      -- Docker: keep LazyVim's dockerls + docker_compose_language_service; Mason auto-enabled a third
      -- server on the same filetypes. (Alternative: keep this one, disable docker_compose_language_service,
      -- and set init_options.dockerfileExperimental.removeOverlappingIssues = true.)
      docker_language_server = { enabled = false },
      -- text/tex/org grammar server: needs a JRE that is not installed; tracebacks on every .txt buffer.
      textlsp = { enabled = false },
      -- emmet abbreviations were diluting vtsls items in TSX; keep it to markup/CSS.
      emmet_language_server = { filetypes = { "html", "css", "scss", "less", "astro" } },
    },
    inlay_hints = { enabled = false },
    diagnostics = {
      virtual_text = false,
      -- LazyVim default; the previous `true` contradicted its own comment and redrew underlines/signs mid-word.
      -- `signs = true` / `underline = true` are intentionally absent: the booleans replaced LazyVim's icon
      -- table (signs.text) and the gutter fell back to E/W/I/H.
      update_in_insert = false,
    },
  },
}
