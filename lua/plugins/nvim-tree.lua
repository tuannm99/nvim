return {
    {
        "kyazdani42/nvim-tree.lua",
        lazy = false,

        opts = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            return {
                update_focused_file = {
                    enable = true,
                    update_cwd = false,
                },
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 50,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false,
                },
                diagnostics = {
                    enable = true,
                },
            }
        end,
        config = function(_, opts)
            require("nvim-tree").setup(opts)
        end,
    },
}
