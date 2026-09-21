-- SchemaStore only matches **/.claude/settings.json; add the project-local file you edit most.
-- Replaces LazyVim's jsonls before_init with the same body plus `extra`.
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jsonls = {
        before_init = function(_, cfg)
          cfg.settings.json.schemas = cfg.settings.json.schemas or {}
          vim.list_extend(
            cfg.settings.json.schemas,
            require("schemastore").json.schemas({
              extra = {
                {
                  name = "Claude Code Settings (local)",
                  description = "Claude Code project-local settings",
                  fileMatch = { "**/.claude/settings.local.json" },
                  url = "https://www.schemastore.org/claude-code-settings.json",
                },
              },
            })
          )
        end,
      },
    },
  },
}
