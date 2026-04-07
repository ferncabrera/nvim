-- Layout 2: Chafa Block + Dither — Side-pane image, keys on left
-- Block characters (▀▄█) give a chunky, retro-poster look.
-- Floyd-Steinberg dithering smooths gradients nicely.
--
-- The image sits in pane 2 (right side) so it acts as a persistent
-- backdrop while your keys and project info stay on the left.

local pic_dir = "/Users/fcabrera/Desktop/dashboard_pics/"

local function random_pic()
  local cmd = string.format("ls '%s' | shuf -n1", pic_dir)
  local handle = io.popen(cmd)
  if not handle then
    return ""
  end
  local file = handle:read("*l") or ""
  handle:close()
  return pic_dir .. file
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
        {
          pane = 2,
          section = "terminal",
          cmd = string.format(
            "chafa '%s' --format symbols --symbols block --size 60x35 --colors full --work 9 --dither fs --animate off",
            random_pic()
          ),
          height = 20,
          padding = 1,
        },
        {
          pane = 2,
          icon = " ",
          title = "Git Status",
          section = "terminal",
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
