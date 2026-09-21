-- Task lists Claude writes in plans / PR bodies / CLAUDE.md (`- [ ]`, `- [x]`) render as raw brackets
-- because the markdown extra disables checkboxes.
return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 ", scope_highlight = "@markup.strikethrough" },
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        blocked = { raw = "[!]", rendered = "󰀦 ", highlight = "DiagnosticError" },
      },
    },
  },
}
