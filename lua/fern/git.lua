-- Small git helpers shared by the diffview keys and the gitsigns base toggle.
local M = {}

local function git(args, cwd)
  local res = vim.system(vim.list_extend({ "git" }, args), { text = true, cwd = cwd }):wait()
  return res.code == 0 and vim.trim(res.stdout or "") or nil
end

--- Repo root of the current buffer (worktrees have a `.git` file, which vim.fs.root also finds).
function M.root()
  return vim.fs.root(0, ".git") or vim.fn.getcwd()
end

--- "origin/main" (whatever origin/HEAD points at), falling back to the first ref that exists.
function M.default_base()
  local cwd = M.root()
  local head = git({ "symbolic-ref", "--short", "refs/remotes/origin/HEAD" }, cwd)
  if head then
    return head
  end
  for _, ref in ipairs({ "origin/main", "origin/master", "main", "master" }) do
    if git({ "rev-parse", "--verify", "--quiet", ref }, cwd) then
      return ref
    end
  end
  return nil
end

--- merge-base(HEAD, default branch): everything this branch (+ working tree) changed.
---@return string|nil sha, string|nil base
function M.merge_base()
  local base = M.default_base()
  if not base then
    return nil, nil
  end
  return git({ "merge-base", "HEAD", base }, M.root()), base
end

return M
