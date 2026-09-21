-- Layout 2: Chafa Block + Dither — Side-pane image, keys on left
-- Block characters (▀▄█) give a chunky, retro-poster look.
-- Floyd-Steinberg dithering smooths gradients nicely.
--
-- The image sits in pane 2 (right side) so it acts as a persistent
-- backdrop while your keys and project info stay on the left.

local pic_dir = vim.fn.expand("~/Desktop/dashboard_pics/")

local function random_pic()
  local files = vim.fn.readdir(pic_dir, function(n)
    -- callback must return 1/0; skip dotfiles (.DS_Store) exactly like plain ls did
    return n:sub(1, 1) ~= "." and 1 or 0
  end)
  if not files or #files == 0 then
    return nil
  end
  math.randomseed(vim.uv.hrtime())
  return pic_dir .. files[math.random(#files)]
end

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      preset = {},
      sections = {
        -- ── Left pane: keys + recent files ─────────────────────────
        { section = "keys", gap = 1, padding = 2 },
        {
          icon = " ",
          title = "Recent Files",
          section = "recent_files",
          indent = 2,
          padding = 1,
        },
        { section = "startup" },

        -- ── Right pane: block-art image ────────────────────────────
        -- a function entry is only evaluated when the dashboard actually renders; the previous
        -- `ls | shuf` io.popen ran while lazy.nvim parsed the spec, on every launch incl. `nvim file`
        function()
          local pic = random_pic()
          if not pic or vim.fn.executable("chafa") == 0 then
            return {}
          end
          return {
            pane = 2,
            section = "terminal",
            height = 20,
            padding = 1, -- default ttl: chafa output is cached per picture (the cmd is the cache key)
            cmd = ("chafa %s --format symbols --symbols block --size 60x35 --colors full --work 9 --dither fs --animate off"):format(
              vim.fn.shellescape(pic)
            ),
          }
        end,
        {
          pane = 2,
          icon = "\u{E725} ",
          title = "Git Status",
          section = "terminal",
          ttl = 5 * 60, -- default is 3600 s: the dashboard showed hour-old git status
          enabled = function()
            return Snacks.git.get_root() ~= nil
          end,
          cmd = "git status --short --branch --renames",
          height = 5,
          padding = 1,
        },
      },
    },
  },
}
