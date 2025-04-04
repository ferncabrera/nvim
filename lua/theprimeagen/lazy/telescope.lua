return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local telescope = require("telescope")

        telescope.setup({
            extensions = {
                oil = {
                    hidden = true,
                    debug = false,
                    no_ignore = false,
                    show_preview = true,
                },
                media_files = {
                    -- filetypes whitelist
                    -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
                    filetypes = { "png", "webp", "jpg", "jpeg" },
                    -- find command (defaults to `fd`)
                    find_cmd = "rg"
                },
                file_browser = {
                    theme = "ivy",
                    hijack_netrw = true, -- disables netrw in favor of telescope-file-browser
                },
            },
        })

        telescope.load_extension("file_browser")
        telescope.load_extension("media_files")
        telescope.load_extension("oil")

        local builtin = require("telescope.builtin")

        --! REQUIRED SINCE FOR SOME REASON Projects.nvim CALLS IT AS A BUILTIN
        -- Reassign the file_browser function into the builtin table.
        builtin.file_browser = telescope.extensions.file_browser.file_browser

        -- For raw folder and git project searches
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>pl', builtin.lsp_document_symbols, {})

        -- For quickly searching words that the cursor is hovering over
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)

        -- Live and efficient greps
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = 'Telescope live grep' })

        -- Some quick reference links
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

        -- New key mapping for file browser previewer
        vim.keymap.set('n', '<leader>fb', builtin.file_browser, { desc = "File Browser" })

         -- New key mapping for oil-telescope
        vim.keymap.set('n', '<leader>-', function()
            telescope.extensions.oil.oil()
        end, { desc = "Oil-Telescope" })

        -- New key mapping for media files
        vim.keymap.set('n', '<leader>fm', function()
            telescope.extensions.media_files.media_files()
        end, { desc = "Media Files" })
    end,
}
