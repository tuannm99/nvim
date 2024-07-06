return {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "ThePrimeagen/harpoon",
            "nvim-telescope/telescope-dap.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        event = "VeryLazy",
        config = function()
            local status_ok, telescope = pcall(require, "telescope")
            if not status_ok then
                return
            end

            local actions = require "telescope.actions"

            telescope.setup {
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                    file_ignore_patterns = { ".git/", "node_modules/", "__pycache__/", "build/", "dist/", "target/" },
                    mappings = {
                        i = {
                            ["<Down>"] = actions.cycle_history_next,
                            ["<Up>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "ignore_case",      -- or "ignore_case" or "respect_case"
                    },
                },
            }

            telescope.load_extension "dap"
            telescope.load_extension "harpoon"
            telescope.load_extension "fzf"
        end,
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        lazy = true,
    },
}
