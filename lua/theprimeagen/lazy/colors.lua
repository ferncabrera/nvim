function ColorMyPencils(color, transparent)
    color = color or "kanagawa-lotus"
    vim.cmd.colorscheme(color)

end

return {
        "rebelot/kanagawa.nvim",
        lazy = false, -- Ensure it's loaded immediately
        config = function()
            require("kanagawa").setup({
                -- theme = "lotus",
            })
            ColorMyPencils("kanagawa-lotus", true) -- Apply colorscheme after loading
        end
    }

