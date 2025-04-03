return
{
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
        -- check the installation instructions at
        -- https://github.com/folke/snacks.nvim
        "folke/snacks.nvim"
    },
    keys = {
        -- 👇 in this section, choose your own keymappings!
        {
            "<leader>-",
            mode = { "n", "v" },
            "<cmd>Yazi<cr>",
            desc = "Open yazi at the current file",
        },
        {
            -- Open in the current working directory
            "<leader>cw",
            "<cmd>Yazi cwd<cr>",
            desc = "Open the file manager in nvim's working directory",
        },
        {
            -- Open in the current working directory
            "<leader>pv",
            "<cmd>Yazi cwd<cr>",
            desc = "Open the file manager in nvim's working directory",
        },
        -- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
        {
            "<leader>to",
            "<cmd>Yazi toggle<cr>",
            desc = "Resume the last yazi session",
        },
    },
    opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
            show_help = "<f1>",
        },
    },
}
