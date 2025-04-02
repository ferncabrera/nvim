-- Thanks to Evgeni Chasnovski for amazing plugins
--@see https://github.com/echasnovski/mini.nvim

local window = function()
    return vim.api.nvim_win_get_number(0)
end

return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
        require("lualine").setup(
            {
              options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '|', right = '|'},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                  statusline = {},
                  winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                  statusline = 100,
                  tabline = 100,
                  winbar = 100,
                }
              },
              sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype', 'lsp_status' },
                lualine_y = {'progress'},
                lualine_z = {'location'}
              },
              inactive_sections = {
                lualine_a = {},
                lualine_b = {"filename"},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {'progress'},
                lualine_z = {'location'}
              },
              tabline = {
                -- lualine_a = {"filename"},
                -- lualine_b = { window },
                },
              winbar = {
                lualine_a = {},
                lualine_z = { window },
                },
              inactive_winbar = {
                lualine_a = {},
                lualine_z = { window },
                },
                extensions =
                    {
                        "oil",
                        "fugitive",
                        "mason",
                        "trouble",
                        "lazy",
                        -- "man"
                    }
            }
        )
    end
}
