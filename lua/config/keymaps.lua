-- require("fern.discipline").cowboy() -- hjkl-spam nag, off by choice

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Comment toggle with <C-/> (and <C-_>, which is what many terminal emulators
-- actually send for Ctrl+/). This overrides the LazyVim default that opens a
-- terminal on <C-/>. gcc/gc come from the mini.comment extra.
vim.keymap.set("n", "<C-/>", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("x", "<C-/>", "gc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("n", "<C-_>", "gcc", { remap = true, silent = true, desc = "Toggle comment" })
vim.keymap.set("x", "<C-_>", "gc", { remap = true, silent = true, desc = "Toggle comment" })

vim.keymap.set("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save" })

-- Take lines and move them (VSCode opt/alt functionality)
-- vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines but keep the cursor where it was
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- For jumping up and down the page
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- For diffing all open windows
vim.keymap.set("n", "<leader>td", function()
  local diff = vim.wo.diff
  if diff then
    vim.cmd("diffoff!")
  else
    vim.cmd("windo diffthis")
  end
end, { desc = "Toggle diff for all windows" })

-- greatest remap ever
-- vim.keymap.set("x", "<leader>pp", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({ "n", "v" }, "<leader>ty", [["+y]], { desc = "greatest remap ever" })
-- vim.keymap.set("n", "<leader>tY", [["+Y]], { desc = "greatest remap ever (line-mode)" })

-- Delete to void register
-- vim.keymap.set({ "n", "v" }, "<leader>pd", '"_d', { desc = "primeage void register delete" })

-- Sweet regex string replacement and easily create executable file!!!
vim.keymap.set(
  "n",
  "<leader>ts",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "primeagen string swap" }
)
vim.keymap.set(
  "n",
  "<leader>tS",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gcI<Left><Left><Left><Left>]],
  { desc = "primeagen string swap (prompt)" }
)
vim.keymap.set("n", "<leader>tx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable (chmod +x)" })

-- Exit easy!!!!!
vim.keymap.set("i", "jj", "<Esc>", { noremap = false })
vim.keymap.set("i", "jk", "<Esc>", { noremap = false })

-- C root
vim.keymap.set("n", "<leader>t.", "<cmd>LazyRoot<CR>", { desc = "LazyRoot" })

-- Better resizing
vim.keymap.set("n", "<leader>w>", "<cmd>vertical resize +20<CR>", { desc = "Increase window width (20)" })
vim.keymap.set("n", "<leader>w<", "<cmd>vertical resize -20<CR>", { desc = "Decrease window width (20)" })

-- Better resizing (vert)
vim.keymap.set("n", "<leader>w+", "<cmd>resize +10<CR>", { desc = "Increase window height (10)" })
vim.keymap.set("n", "<leader>w-", "<cmd>resize -10<CR>", { desc = "Decrease window height (10)" })

vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
vim.keymap.set("n", "q", "<Nop>", { noremap = true, desc = "Disable q macro" })

-- Copy the file name / full path / cwd-relative path of the current buffer to the clipboard.
-- (<leader>tf used expand("%"), which is only a full path when the file was opened by an absolute name.)
local function yank_path(mod, label)
  return function()
    local p = vim.fn.expand("%" .. mod)
    if p == "" then
      return vim.notify("No file in buffer", vim.log.levels.WARN)
    end
    vim.fn.setreg("+", p)
    vim.notify("Copied " .. label .. ": " .. p)
  end
end
vim.keymap.set("n", "<leader>tc", yank_path(":t", "file name"), { desc = "Copy file name" })
vim.keymap.set("n", "<leader>tf", yank_path(":p", "full path"), { desc = "Copy full path" })
vim.keymap.set("n", "<leader>tp", yank_path(":.", "relative path"), { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>to", ":e <C-r>+<CR>", { noremap = true, desc = "Go to location in clipboard" })

-- <leader>qq: LazyVim's default Quit All (the CopilotChat save branch here could never run: copilotchat.lua returns {})

-- Toggle vim-dadbod's default connection (:DB + completion) from the project env instead of a
-- hardcoded URL. Reads ecolog's DATABASE_URL, then $DBUI_URL / $DATABASE_URL.
vim.keymap.set("n", "<leader>tD", function()
  if vim.g.db then
    vim.g.db = nil
    return vim.notify("DB connection unset", vim.log.levels.INFO)
  end
  local vars = require("ecolog").get_env_vars()
  local url = (vars.DATABASE_URL and vars.DATABASE_URL.raw_value) or vim.env.DBUI_URL or vim.env.DATABASE_URL
  if not url then
    return vim.notify("No DATABASE_URL / DBUI_URL in env", vim.log.levels.WARN)
  end
  vim.g.db = url
  vim.notify("DB connection set from env (" .. url:gsub("//.-@", "//***@") .. ")", vim.log.levels.INFO)
end, { desc = "Toggle DB connection (from env)" })

vim.g.snacks_animate = false

vim.g.incline_show_git_diff = true
vim.g.incline_show_diagnostics = true
vim.g.incline_show_navic = false
-- vim.notify is already routed through noice; requiring noice here only hard-coupled this file to its load order
local function notify_toggle(name, state)
  if state then
    vim.notify(name .. ": ON", vim.log.levels.INFO)
  else
    vim.notify(name .. ": OFF", vim.log.levels.WARN)
  end
end

vim.keymap.set("n", "<leader>tg", function()
  vim.g.incline_show_git_diff = not vim.g.incline_show_git_diff
  notify_toggle("Incline Git Diff", vim.g.incline_show_git_diff)
end, { desc = "Toggle incline_show_git_diff", silent = true })

vim.keymap.set("n", "<leader>ti", function()
  vim.g.incline_show_diagnostics = not vim.g.incline_show_diagnostics
  vim.cmd("redrawstatus!")
  notify_toggle("Incline Diagnostics", vim.g.incline_show_diagnostics)
end, { desc = "Toggle incline_show_diagnostics", silent = true })

vim.keymap.set("n", "<leader>tm", function()
  vim.g.incline_show_navic = not vim.g.incline_show_navic
  vim.cmd("redrawstatus!")
  notify_toggle("Incline Navic", vim.g.incline_show_navic)
end, { desc = "Toggle incline_show_navic", silent = true })

-- Toggle the (custom) statusline. Relocated here from the disabled lualine spec
-- so it no longer relies on a side effect inside a plugin table.
vim.keymap.set("n", "<leader>tt", function()
  if vim.o.laststatus == 0 then
    vim.o.laststatus = 3
  else
    vim.o.laststatus = 0
  end
end, { desc = "Toggle Statusline" })

-- vim.keymap.set("n", "<C-c>", "<cmd>qa<CR>", { desc = "Quit All" })

-- Semantic tokens per buffer/client (vtsls/gopls/rust-analyzer compute + decode them after every edit;
-- treesitter already provides nearly everything kanagawa uses). Toggle to measure on big TS files.
Snacks.toggle({
  name = "Semantic Tokens",
  get = function()
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0, method = "textDocument/semanticTokens/full" })) do
      if vim.lsp.semantic_tokens.is_enabled({ bufnr = 0, client_id = c.id }) then
        return true
      end
    end
    return false
  end,
  set = function(state)
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0, method = "textDocument/semanticTokens/full" })) do
      vim.lsp.semantic_tokens.enable(state, { bufnr = 0, client_id = c.id })
    end
  end,
}):map("<leader>uH")

-- ── Reviewing agent changes ────────────────────────────────────────────────────────────────────
-- Point gitsigns at merge-base(default branch) so every hunk the branch (or an agent) produced shows in
-- the gutter with ]h/[h/<leader>ghp while you edit; while active <leader>ghr/ghR revert committed changes.
vim.keymap.set("n", "<leader>tb", function()
  local gs = require("gitsigns")
  if vim.g.gitsigns_review_base then
    vim.g.gitsigns_review_base = nil
    gs.change_base(nil, true)
    return vim.notify("gitsigns: base = index")
  end
  local sha, base = require("fern.git").merge_base()
  if not sha then
    return vim.notify("gitsigns: no default branch / merge-base found", vim.log.levels.WARN)
  end
  vim.g.gitsigns_review_base = sha
  gs.change_base(sha, true)
  vim.notify(("gitsigns: base = merge-base(%s) %s"):format(base, sha:sub(1, 8)))
end, { desc = "Toggle hunks vs main (review agent branch)" })

-- Hop between git worktrees (parallel Claude sessions): new tab, tcd, file picker
vim.keymap.set("n", "<leader>gw", function()
  local out = vim.system({ "git", "worktree", "list", "--porcelain" }, { text = true }):wait().stdout or ""
  local items = {}
  for block in (out .. "\n\n"):gmatch("(.-)\n\n") do
    local path = block:match("^worktree ([^\n]+)")
    if path then
      local branch = block:match("\nbranch refs/heads/([^\n]+)") or "(detached)"
      items[#items + 1] = { text = ("%-45s %s"):format(branch, vim.fn.fnamemodify(path, ":~")), path = path }
    end
  end
  Snacks.picker({
    title = "Git Worktrees",
    items = items,
    format = "text",
    layout = { preset = "select" },
    confirm = function(picker, item)
      picker:close()
      vim.cmd.tabnew()
      vim.cmd.tcd(vim.fn.fnameescape(item.path))
      Snacks.picker.files({ cwd = item.path })
    end,
  })
end, { desc = "Git worktrees (Claude sessions)" })

-- ── Claude Code in the tmux popup (no plugin) ──────────────────────────────────────────────────
-- Sessions are created by ~/.config/tmux/scripts/claude-popup.sh as "claude-<full path slug>", possibly
-- for a sub-project, so try cwd, LazyVim root and git root.
function _G.claude_target()
  for _, dir in ipairs({ vim.fn.getcwd(), LazyVim.root(), LazyVim.root.git() }) do
    if dir and dir ~= "" then
      local target = "=claude-" .. (dir:gsub("[^%w_%-]", "_"))
      if vim.system({ "tmux", "has-session", "-t", target }):wait().code == 0 then
        return target, dir
      end
    end
  end
  return nil
end

-- Mirror tmux.reset.conf: inside a claude-*/misc-* session switch-client instead of nesting a popup
function _G.claude_popup(target)
  local cur = vim.trim(vim.fn.system({ "tmux", "display-message", "-p", "#{session_name}" }))
  if cur:match("^claude%-") or cur:match("^misc%-") then
    vim.system({ "tmux", "switch-client", "-t", target })
  else
    vim.system({
      "tmux",
      "display-popup",
      "-w",
      "92%",
      "-h",
      "85%",
      "-x",
      "C",
      "-y",
      "C",
      "-b",
      "rounded",
      "-E",
      "tmux attach-session -t " .. target,
    })
  end
end

local function with_claude(build)
  local target, root = claude_target()
  if not target then
    return vim.notify("No Claude tmux session for this project (prefix ^A to start one)", vim.log.levels.WARN)
  end
  vim.system({ "tmux", "send-keys", "-t", target, "-l", build(root) }):wait()
  claude_popup(target)
end

local function relpath(root)
  return vim.fs.relpath(root, vim.api.nvim_buf_get_name(0)) or vim.fn.expand("%:.")
end

vim.keymap.set("n", "<leader>ta", function()
  with_claude(function(root)
    return "@" .. relpath(root) .. " "
  end)
end, { desc = "Claude: send @file" })

vim.keymap.set("x", "<leader>ta", function()
  local s, e = vim.fn.line("v"), vim.fn.line(".")
  if s > e then
    s, e = e, s
  end
  with_claude(function(root)
    return ("@%s (lines %d-%d) "):format(relpath(root), s, e)
  end)
end, { desc = "Claude: send @file + line range" })

-- Draft long prompts in <leader>. (Snacks scratch) and ship the buffer/selection as one bracketed paste
vim.keymap.set({ "n", "x" }, "<leader>tA", function()
  local text
  if vim.fn.mode():match("[vV\22]") then
    vim.cmd([[silent normal! "zy]])
    text = vim.fn.getreg("z")
  else
    text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  end
  local target = claude_target()
  if not target then
    return vim.notify("No Claude tmux session for this project", vim.log.levels.WARN)
  end
  vim.system({ "tmux", "load-buffer", "-b", "nvim2claude", "-" }, { stdin = text }):wait()
  vim.system({ "tmux", "paste-buffer", "-p", "-d", "-b", "nvim2claude", "-t", target }):wait() -- bracketed paste
  claude_popup(target)
end, { desc = "Claude: paste buffer/selection as prompt" })

-- ── Project-wide typecheck into quickfix/Trouble after an agent run ────────────────────────────
-- vtsls only diagnoses open buffers. Run from a buffer inside a package with tsconfig.json.
local function project_check(cmd, efm, name)
  return function()
    vim.notify(name .. " running...", vim.log.levels.INFO, { title = "check" })
    local cwd = vim.fs.root(0, "tsconfig.json") or LazyVim.root()
    vim.system(
      cmd,
      { cwd = cwd, text = true },
      vim.schedule_wrap(function(res)
        local out = (res.stdout or "") .. (res.stderr or "")
        vim.fn.setqflist({}, " ", { title = name, lines = vim.split(out, "\n", { trimempty = true }), efm = efm })
        if #vim.fn.getqflist() == 0 then
          vim.notify(name .. ": clean", vim.log.levels.INFO, { title = "check" })
        else
          require("trouble").open("qflist")
        end
      end)
    )
  end
end
-- errorformat from $VIMRUNTIME/compiler/tsc.vim
vim.keymap.set(
  "n",
  "<leader>ck",
  project_check(
    { "npx", "tsc", "--noEmit", "--pretty", "false" },
    "%f %#(%l\\,%c): %trror TS%n: %m,%trror TS%n: %m,%-G%.%#",
    "tsc"
  ),
  { desc = "Typecheck project (tsc)" }
)
