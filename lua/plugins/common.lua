return {
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
    },

    {
        "kyazdani42/nvim-web-devicons",
        lazy = false,
    },

    {
        "alexghergh/nvim-tmux-navigation",
        event = "VeryLazy",
        config = function()
            require("nvim-tmux-navigation").setup {
                disable_when_zoomed = true,
                keybindings = {
                    left = "<C-h>",
                    down = "<C-j>",
                    up = "<C-k>",
                    right = "<C-l>",
                },
            }
        end,
    },

    {
        "moll/vim-bbye",
        event = "VeryLazy",
    },

    {
        "ThePrimeagen/harpoon",
        lazy = false,
    },

    {
        "nvim-pack/nvim-spectre",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    {
        "szw/vim-maximizer",
        event = "VeryLazy",
    },

    -- {
    --     "tuannm99/filetype.nvim",
    --     event = "VeryLazy",
    -- },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 200
            require("which-key").setup {}
        end,
    },

    {
        "LunarVim/bigfile.nvim",
        lazy = false,
    },
}
