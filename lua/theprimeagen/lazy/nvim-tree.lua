return {
    "ahmedkhalf/project.nvim",
    opts = {
        manual_mode = true,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = true
        },
        silent_chdir = false,
        show_hidden = true,
    },
    event = "VeryLazy",
    config = function(_, opts)
        require("project_nvim").setup(opts)
        local history = require("project_nvim.utils.history")
        history.delete_project = function(project)
            for k, v in pairs(history.recent_projects) do
                if v == project.value then
                    history.recent_projects[k] = nil
                    return
                end
            end
        end
        require("lazy").load({ plugins = { "telescope.nvim" } }) -- Correct way to lazy-load
        require("telescope").load_extension("projects")
        -- Add <leader>pp keybinding for the projects extension
        vim.keymap.set("n", "<leader>pp", function()
            require("telescope").extensions.projects.projects()
        end, { desc = "Projects List" })
    end,
}


-- return {
--     "ahmedkhalf/project.nvim",
--     lazy = true,
--     config = function()
--         -- lua
--         require("project_nvim").setup({
--           sync_root_with_cwd = true,
--           respect_buf_cwd = true,
--           update_focused_file = {
--             enable = true,
--             update_root = true
--           },
--         })
--   end
-- }
--
