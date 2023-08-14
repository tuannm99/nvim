return {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local theme = require "dracula"
        theme.setup {
            show_end_of_buffer = true,
            transparent_bg = true,
            lualine_bg_color = "#44475a",
            italic_comment = true,
        }
        theme.load()
    end,
}
