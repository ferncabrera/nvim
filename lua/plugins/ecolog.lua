return {
  "ph1losof/ecolog.nvim",
  branch = "v1",
  lazy = false,
  keys = {
    { "<leader>e", "", desc = "+ecolog", mode = { "n", "v" } },
    { "<leader>el", "<Cmd>EcologShelterLinePeek<cr>", desc = "Ecolog Peek line" },
    { "<leader>ey", "<Cmd>EcologCopy<cr>", desc = "Ecolog Copy value under cursor" },
    { "<leader>ei", "<Cmd>EcologInterpolationToggle<cr>", desc = "Ecolog Toggle interpolation" },
    { "<leader>eh", "<Cmd>EcologShellToggle<cr>", desc = "Ecolog Toggle shell variables" },
    { "<leader>eg", "<cmd>EcologGoto<cr>", desc = "Ecolog Go to env file" },
    { "<leader>ec", "<cmd>EcologSnacks<cr>", desc = "Ecolog Open a picker" },
    { "<leader>se", "<cmd>EcologSnacks<cr>", desc = "Ecolog Open a picker" },
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
        hidden_mode = true,
        icons = { enabled = true, env = "E", shelter = "S" },
        highlights = {
          env_file = "Directory",
          vars_count = "Number",
        },
      },
      -- statusline = {
      --   hidden_mode = false, -- Hide when no env file is loaded
      --   icons = {
      --     enabled = true, -- Enable icons in statusline
      --     env = "🌲", -- Icon for environment file
      --     shelter = "🛡️", -- Icon for shelter mode
      --   },
      --   format = {
      --     env_file = function(name)
      --       return name -- Format environment file name
      --     end,
      --     vars_count = function(count)
      --       return string.format("%d vars", count) -- Format variables count
      --     end,
      --   },
      --   highlights = {
      --     enabled = true, -- Enable custom highlights
      --     env_file = "Directory", -- Highlight group for file name
      --     vars_count = "Number", -- Highlight group for vars count
      --     icons = "Special",
      --   },
      -- },
    },
    shelter = {
      configuration = {
        patterns = {
          ["DATABASE_URL"] = "full",
          ["*_KEY"] = "full",
          ["*TOKEN*"] = "full",
          ["*SECRET*"] = "full",
        },
        sources = {
          ["base.env"] = "none",
          [".env.local"] = "none",
          [".env.example"] = "none",
          [".secrets.template.env"] = "none",
          [".secrets.enc.env"] = "full", -- sops ciphertext: never show as if it were a value
          ["shell"] = "full",
        },
        partial_mode = {
          min_mask = 5,
          show_start = 1,
          show_end = 1,
        },
        mask_char = "*",
      },
      -- cmp/snacks were off, so the blink docs window ("**Value:** ...") and the picker rendered real values
      modules = {
        files = true,
        peek = false,
        snacks_previewer = true,
        snacks = true,
        cmp = true,
      },
    },
    load_shell = {
      enabled = true, -- Enable shell variable loading
      override = false, -- When false, .env files take precedence over shell variables
      -- keep exported tokens/keys (CLAUDE_CODE_*_TOKEN, *_KEY, ...) out of the completion candidates
      filter = function(key)
        return not key:match("TOKEN") and not key:match("SECRET") and not key:match("KEY$")
      end,
      -- the old "[SHELL] " transform was redundant (blink shows detail = "shell"), broke `types = true`
      -- detection and corrupted EcologCopy
    },
    env_file_patterns = {
      "common/config/base.env",
      "common/config/.secrets.template.env",
      "common/config/dev/.env",
      "common/config/dev/.env.local",
      "common/config/dev/.secrets.enc.env",
      "common/config/prod/.env",
      "common/config/prod/.secrets.enc.env",
      ".env",
    },
    path = vim.fn.getcwd(),
  },
}
