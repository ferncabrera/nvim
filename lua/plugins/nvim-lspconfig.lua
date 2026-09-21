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
      -- eslint-lsp uses pull diagnostics: Neovim pulls after every didChange (150 ms debounce). Type-aware
      -- lint of one file costs ~0.6 s in open_ims, so send didChange less often. ESLint code actions and
      -- format-on-save flush pending changes first, so they are not stale; they lag the buffer <= 1 s.
      eslint = { flags = { debounce_text_changes = 1000 } },
      vtsls = {
        settings = {
          -- tsserver can return thousands of auto-import entries per keystroke; blink caps the list at 200.
          vtsls = { experimental = { completion = { entriesLimit = 250 } } },
          typescript = {
            preferences = {
              -- project-dependent: differs from "shortest" only when tsconfig has baseUrl/paths
              importModuleSpecifier = "project-relative",
              -- only matters for verbatimModuleSyntax / consistent-type-imports projects
              preferTypeOnlyAutoImports = true,
              includePackageJsonAutoImports = "on",
            },
          },
          -- javascript.* is copied from typescript.* by LazyVim's vtsls extra
        },
      },
      tailwindcss = {
        settings = {
          tailwindCSS = {
            -- completion/hover/lint inside cn()/clsx()/cva() calls, not only in class="..."
            classFunctions = { "cn", "clsx", "cva", "cx", "tw", "twMerge" },
            -- the server's full default exclude list + the SCSS modules it probed 20,602 times as a "config"
            files = {
              exclude = {
                "**/.git/**",
                "**/.hg/**",
                "**/.svn/**",
                "**/node_modules/**",
                "**/.yarn/**",
                "**/.venv/**",
                "**/venv/**",
                "**/.next/**",
                "**/.parcel-cache/**",
                "**/.svelte-kit/**",
                "**/.turbo/**",
                "**/__pycache__/**",
                "**/*.module.scss",
              },
            },
          },
        },
      },
      -- plain CSS/SCSS: property/value completion, hover, diagnostics, documentColor. Listing it here makes
      -- LazyVim install css-lsp through mason-lspconfig; the scss parser is added in lua/plugins/treesitter.lua.
      cssls = {
        settings = {
          css = { validate = true, lint = { unknownAtRules = "ignore" } }, -- @tailwind / @apply / @layer
          scss = { validate = true, lint = { unknownAtRules = "ignore" } },
        },
      },
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
