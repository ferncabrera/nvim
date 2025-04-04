return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    require("conform").setup({
      formatters_by_ft = {
      }
    })
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "astro"
      },
      automatic_installation = true,
      handlers = {
        function(server_name)         -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,
        ["ts_ls"] = function()
          require("lspconfig").ts_ls.setup({
            capabilities = capabilities,
            settings = {
              typescript = {
                separate_diagnostic_server = true,
                publish_diagnostic_on = "insert_leave",
                tsserver_max_memory = "auto",
                format = {
                  insertSpaceAfterCommaDelimiter = true,
                  insertSpaceAfterConstructor = false,
                  insertSpaceAfterSemicolonInForStatements = true,
                  insertSpaceBeforeAndAfterBinaryOperators = true,
                  insertSpaceAfterKeywordsInControlFlowStatements = true,
                  insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
                  insertSpaceBeforeFunctionParenthesis = false,
                  insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
                  insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
                  insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
                  insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
                  insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
                  insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
                  insertSpaceAfterTypeAssertion = false,
                  placeOpenBraceOnNewLineForFunctions = false,
                  placeOpenBraceOnNewLineForControlBlocks = false,
                  semicolons = "ignore",
                  indentSwitchCase = true,
                },
                preferences = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = false,
                  includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                  includeInlayPropertyDeclarationTypeHints = false,
                  includeInlayFunctionLikeReturnTypeHints = false,
                  includeInlayEnumMemberValueHints = true,
                  quotePreference = "auto",
                  importModuleSpecifierEnding = "auto",
                  jsxAttributeCompletionStyle = "auto",
                  allowTextChangesInNewFiles = true,
                  providePrefixAndSuffixTextForRename = true,
                  allowRenameOfImportPath = true,
                  includeAutomaticOptionalChainCompletions = true,
                  provideRefactorNotApplicableReason = true,
                  generateReturnInDocTemplate = true,
                  includeCompletionsForImportStatements = true,
                  includeCompletionsWithSnippetText = true,
                  includeCompletionsWithClassMemberSnippets = true,
                  includeCompletionsWithObjectLiteralMethodSnippets = true,
                  useLabelDetailsInCompletionEntries = true,
                  allowIncompleteCompletions = true,
                  displayPartsForJSDoc = true,
                  disableLineTextInReferences = true,
                },
              },
            },
          })
        end,
        zls = function()
          local lspconfig = require("lspconfig")
          lspconfig.zls.setup({
            root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)           -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "copilot", group_index = 2 },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },         -- For luasnip users.
      }, {
        { name = 'buffer' },
      })
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
