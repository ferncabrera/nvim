-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- (incline subscribes to ModeChanged itself; the manual refresh here was redundant)

-- (last-position restore is LazyVim's lazyvim_last_loc autocmd)

local augroup = vim.api.nvim_create_augroup("GitUIInclineRefresh", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = augroup,
  pattern = "*",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name:match("gitui") then
      require("incline").disable()
    end
  end,
})

-- Re-enable Incline after GitUI closes
vim.api.nvim_create_autocmd("TermClose", {
  group = augroup,
  pattern = "*",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name:match("gitui") then
      require("incline").enable()
      require("incline").refresh()
    end
  end,
})

-- local yazi_group = vim.api.nvim_create_augroup("YaziInclineRefresh", { clear = true })
--
-- vim.api.nvim_create_autocmd("TermOpen", {
--   group = yazi_group,
--   pattern = "*",
--   callback = function(args)
--     local name = vim.api.nvim_buf_get_name(args.buf)
--     if name:match("yazi") then
--       local pickers = require("snacks.picker.core.picker").get()
--       if #pickers > 0 then
--         pickers[#pickers]:close()
--       end
--       require("incline").disable()
--     end
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("TermClose", {
--   group = yazi_group,
--   pattern = "*",
--   callback = function(args)
--     local name = vim.api.nvim_buf_get_name(args.buf)
--     if name:match("yazi") then
--       require("incline").enable()
--       require("incline").refresh()
--     end
--   end,
-- })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbui",
  callback = function(ev)
    vim.keymap.del("n", "H", { buffer = ev.buf })
  end,
})

-- nvim 0.12 on-type formatting (textDocument/onTypeFormatting): vtsls triggers on `;`, `}` and newline,
-- rust-analyzer on `=`, `.`, `>`, `{`. Whitespace/semicolons snap into place while typing; prettier on
-- save stays the source of truth. lua_ls is left out (EmmyLuaCodeStyle disagrees with stylua).
-- `:lua vim.lsp.on_type_formatting.enable(false)` turns it off; `:checkhealth vim.lsp` shows attachment.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("fern_lsp_012", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    local on_type = { vtsls = true, ["rust-analyzer"] = true }
    if on_type[client.name] and client:supports_method("textDocument/onTypeFormatting", ev.buf) then
      vim.lsp.on_type_formatting.enable(true, { client_id = client.id })
    end
  end,
})

-- ── External edits (Claude Code editing files while they are open) ────────────────────────────
-- LazyVim's checktime only fires on FocusGained/TermClose/TermLeave; while you stay in the nvim pane
-- and an agent edits files elsewhere, buffers went stale until you left and came back. Reloads are
-- undoable (u): 'undofile' + 'undoreload' defaults.
local agent = vim.api.nvim_create_augroup("agent_edits", { clear = true })

-- poll for on-disk changes while idle in normal mode (updatetime = 200 ms) and on buffer enter.
-- CursorHoldI is deliberately absent: checktime in a modified buffer mid-insert pops the W12 prompt.
vim.api.nvim_create_autocmd({ "CursorHold", "BufEnter" }, {
  group = agent,
  callback = function()
    if vim.bo.buftype == "" and vim.fn.getcmdwintype() == "" then
      vim.cmd("silent! checktime")
    end
  end,
})

-- unmodified buffers are auto-reloaded by 'autoread'; say so. Post also fires after the "ask" dialog is
-- answered OK (buffer kept, still modified) and when a deleted file reappears, hence the guard/reset.
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = agent,
  callback = function(ev)
    vim.b[ev.buf].agent_deleted_warned = nil
    if vim.bo[ev.buf].modified then
      return
    end
    Snacks.notify.info(
      ("Reloaded %s from disk (u = undo)"):format(vim.fn.fnamemodify(ev.file, ":.")),
      { title = "External edit" }
    )
  end,
})

-- only reached for modified buffers / deleted files: decide instead of the blocking W12 dialog
vim.api.nvim_create_autocmd("FileChangedShell", {
  group = agent,
  callback = function(ev)
    local name = vim.fn.fnamemodify(ev.file, ":.")
    if vim.v.fcs_reason == "deleted" then
      vim.v.fcs_choice = ""
      -- fires again on every subsequent checktime, so warn once per buffer
      if not vim.b[ev.buf].agent_deleted_warned then
        vim.b[ev.buf].agent_deleted_warned = true
        Snacks.notify.warn(
          name .. " was deleted on disk (buffer kept; <leader>bd to drop)",
          { title = "External edit" }
        )
      end
    elseif vim.bo[ev.buf].modified then
      vim.v.fcs_choice = "ask" -- genuine conflict: you and Claude both changed it
    else
      vim.v.fcs_choice = "reload"
    end
  end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = agent,
  callback = function(ev)
    vim.b[ev.buf].agent_deleted_warned = nil
  end,
})

-- Claude Code prompt files (Ctrl+G / /memory spawn $EDITOR on claude-prompt-<uuid>.md): plain text,
-- no prettier/markdownlint/markdown-toc on :w, no diagnostics, <CR> sends it back.
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("claude_prompt_buffers", { clear = true }),
  pattern = "*/claude-*/claude-prompt-*.md", -- /tmp, /private/tmp and a custom CLAUDE_CODE_TMPDIR
  callback = function(ev)
    vim.b[ev.buf].autoformat = false
    vim.diagnostic.enable(false, { bufnr = ev.buf })
    vim.bo[ev.buf].textwidth = 0
    vim.keymap.set("n", "<CR>", "<cmd>wq<cr>", { buffer = ev.buf, desc = "Send prompt to Claude" })
  end,
})

-- grug-far: toggle hidden/ignored files from inside the search buffer
vim.api.nvim_create_autocmd("FileType", {
  pattern = "grug-far",
  callback = function(ev)
    vim.keymap.set({ "i", "n", "x" }, "<A-h>", function()
      local state = unpack(require("grug-far").get_instance(0):toggle_flags({ "--hidden", "--glob !.git/" }))
      vim.notify("grug-far: toggled --hidden --glob !.git/ " .. (state and "ON" or "OFF"))
    end, { desc = "Toggle Hidden Files", buffer = ev.buf })

    vim.keymap.set({ "i", "n", "x" }, "<A-i>", function()
      local state = unpack(require("grug-far").get_instance(0):toggle_flags({ "--no-ignore" }))
      vim.notify("grug-far: toggled --no-ignore " .. (state and "ON" or "OFF"))
    end, { desc = "Toggle Ignored Files", buffer = ev.buf })
  end,
})

-- The only owner of the custom highlight groups, driven by kanagawa's palette so light/dark switches
-- (<leader>ub) recolour everything. Previously three ColorScheme handlers fought over StatusLine*
-- with hex values hardcoded per MODE/THEME.
local function custom_hl()
  if vim.g.colors_name ~= "kanagawa" then
    return
  end
  local ok, colors = pcall(function()
    return require("kanagawa.colors").setup()
  end)
  if not ok then
    return
  end
  local t = colors.theme
  local k = require("kanagawa")
  vim.g.kanagawa_bg, vim.g.kanagawa_fg = t.ui.bg, t.ui.fg
  vim.g.kanagawa_variant = k._CURRENT_THEME or k.config.background[vim.o.background] -- "dragon" | "lotus", for incline
  vim.api.nvim_set_hl(0, "StatusLine", { fg = t.ui.fg, bg = t.ui.bg })
  vim.api.nvim_set_hl(0, "StatusLineBG", { bg = t.ui.bg })
  vim.api.nvim_set_hl(0, "StatusLinePath", { fg = t.ui.fg, bg = t.ui.bg, bold = true })
  vim.api.nvim_set_hl(0, "StatusLineEnv", { fg = t.ui.fg_dim, bg = t.ui.bg, italic = true })
  -- macro-recording pill: fixed #e46876 in every variant, edges drawn in the same colour on the bar bg
  vim.api.nvim_set_hl(0, "StatusLineRec", { fg = t.ui.bg, bg = "#e46876", bold = true })
  vim.api.nvim_set_hl(0, "StatusLineRecEdge", { fg = "#e46876", bg = t.ui.bg })
  vim.api.nvim_set_hl(0, "InclineModified", { fg = "#EEF5FF" })
  vim.api.nvim_set_hl(0, "MatchParen", { fg = "#EEF5FF", bg = "#D27E99", bold = true })
  -- flash.nvim labels (previously set once via :hi in the flash spec and lost on colorscheme reload)
  vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#f2ecbc", bg = "#b35b79" })
  vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "#f2ecbc", bg = "#e98a00" })
  vim.api.nvim_set_hl(0, "FlashPromptIcon", { fg = "#b35b79" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("fern_hl", { clear = true }),
  pattern = "kanagawa",
  callback = custom_hl,
})
custom_hl() -- autocmds.lua loads at VeryLazy, after the colorscheme already ran

local ns = vim.api.nvim_create_namespace("oil_highlight_entry")
vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = function(args)
    local bufnr = args.data.buf
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        return
      end
      local winid = vim.fn.bufwinid(bufnr)
      if winid == -1 then
        return
      end

      vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

      local ok, oil = pcall(require, "oil")
      if not ok then
        return
      end

      local entry
      vim.api.nvim_win_call(winid, function()
        entry = oil.get_cursor_entry()
      end)
      if not entry then
        return
      end

      local lnum = vim.api.nvim_win_get_cursor(winid)[1] - 1
      local line = vim.api.nvim_buf_get_lines(bufnr, lnum, lnum + 1, false)[1]
      if not line then
        return
      end

      local col = string.find(line, entry.name, 1, true)
      if col then
        vim.api.nvim_buf_set_extmark(bufnr, ns, lnum, col - 1, {
          end_col = col - 1 + #entry.name,
          hl_group = "Visual",
        })
        vim.defer_fn(function()
          pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns, 0, -1)
        end, 1500)
      end
    end)
  end,
})
