return {
  "ph1losof/ecolog.nvim",
  branch = "beta",
  lazy = false,
  keys = {
    { "<leader>e", "", desc = "+yazi/ecolog", mode = { "n", "v" } },
    { "<leader>el", "<Cmd>EcologShelterLinePeek<cr>", desc = "Ecolog Peek line" },
    { "<leader>ey", "<Cmd>EcologCopy<cr>", desc = "Ecolog Copy value under cursor" },
    { "<leader>ei", "<Cmd>EcologInterpolationToggle<cr>", desc = "Ecolog Toggle interpolation" },
    { "<leader>eh", "<Cmd>EcologShellToggle<cr>", desc = "Ecolog Toggle shell variables" },
    { "<leader>ge", "<cmd>EcologGoto<cr>", desc = "Ecolog Go to env file" },
    { "<leader>ec", "<cmd>EcologSnacks<cr>", desc = "Ecolog Open a picker" },
    { "<leader>eS", "<cmd>EcologSelect<cr>", desc = "Ecolog Switch env file" },
    { "<leader>es", "<cmd>EcologShelterToggle<cr>", desc = "Ecolog Shelter toggle" },
  },
  opts = {
    preferred_environment = "local",
    types = true,
    monorepo = {
      enabled = true,
      auto_switch = true,
      notify_on_switch = false,
    },
    providers = {
      {
        pattern = "{{[%w_]+}}?$",
        filetype = "http",
        extract_var = function(line, col)
          local utils = require("ecolog.utils")
          return utils.extract_env_var(line, col, "{{([%w_]+)}}?$")
        end,
        get_completion_trigger = function()
          return "{{"
        end,
      },
    },
    interpolation = {
      enabled = true,
      features = {
        commands = false,
      },
    },
    sort_var_fn = function(a, b)
      if a.source == "shell" and b.source ~= "shell" then
        return false
      end
      if a.source ~= "shell" and b.source == "shell" then
        return true
      end

      return a.name < b.name
    end,
    integrations = {
      lspsaga = false,
      blink_cmp = true,
      snacks = true,
      statusline = {
        hidden_mode = false, -- Hide when no env file is loaded
        icons = {
          enabled = true, -- Enable icons in statusline
          env = "🌲", -- Icon for environment file
          shelter = "🛡️", -- Icon for shelter mode
        },
        format = {
          env_file = function(name)
            return name -- Format environment file name
          end,
          vars_count = function(count)
            return string.format("%d vars", count) -- Format variables count
          end,
        },
        highlights = {
          enabled = true, -- Enable custom highlights
          env_file = "Directory", -- Highlight group for file name
          vars_count = "Number", -- Highlight group for vars count
          icons = "Special",
        },
      },
    },
    shelter = {
      configuration = {
        patterns = {
          ["DATABASE_URL"] = "full",
        },
        sources = {
          [".env.example"] = "none",
          [".secrets.template.env"] = "none",
        },
        partial_mode = {
          min_mask = 5,
          show_start = 1,
          show_end = 1,
        },
        mask_char = "*",
      },
      modules = {
        files = true,
        peek = false,
        snacks_previewer = true,
        snacks = false,
        cmp = false,
      },
    },
    load_shell = {
      enabled = true, -- Enable shell variable loading
      override = false, -- When false, .env files take precedence over shell variables
      -- Optional: filter specific shell variables
      -- filter = function(key, value)
      --   -- Example: only load specific variables
      --   return key:match("^(PATH|HOME|USER)$") ~= nil
      -- end,
      -- Optional: transform shell variables before loading
      transform = function(key, value)
        -- Example: prefix shell variables for clarity
        return "[SHELL] " .. value
      end,
    },
    env_file_patterns = {
      "common/config/dev/.env",
      "common/config/dev/.secrets.env",
      "common/config/prod/.env",
      "common/config/prod/.secrets.env",
    },
    path = vim.fn.getcwd(),
  },
}
