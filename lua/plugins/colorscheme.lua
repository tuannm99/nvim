-- return {
--     "Mofiqul/dracula.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         local theme = require "dracula"
--         theme.setup {
--             show_end_of_buffer = true,
--             transparent_bg = true,
--             lualine_bg_color = "#44475a",
--             italic_comment = true,
--         }
--         theme.load()
--     end,
-- }

return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            styles = {
                bold = true,
                italic = true,
                transparency = true,
            },

        })
        vim.cmd("colorscheme rose-pine-moon")
    end
}
