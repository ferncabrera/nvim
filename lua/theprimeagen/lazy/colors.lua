function ColorMyPencils(color, transparent)
    color = color or "gruvbox"
    vim.cmd.colorscheme(color)
end

return {
    "ellisonleao/gruvbox.nvim",
    lazy = false,     -- Ensure it's loaded immediately
    config = function()
        require("gruvbox").setup({
            terminal_colors = true, -- add neovim terminal colors
            undercurl = true,
            underline = true,
            bold = true,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            strikethrough = true,
            invert_selection = false,
            invert_signs = false,
            invert_tabline = false,
            invert_intend_guides = false,
            inverse = true, -- invert background for search, diffs, statuslines and errors
            contrast = "", -- can be "hard", "soft" or empty string
            palette_overrides = {},
            overrides = {},
            dim_inactive = false,
            transparent_mode = false,
        })
        ColorMyPencils("gruvbox", true)     -- Apply colorscheme after loading
    end
}
