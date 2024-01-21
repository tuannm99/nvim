return {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    build = ":TSUpdate",
    priority = 500,
    config = function(_, opts)
        local treesitter = require "nvim-treesitter"
        local configs = require "nvim-treesitter.configs"

        configs.setup {
            ensure_installed = {
                "vue",
                "html",
                "lua",
                "markdown",
                "markdown_inline",
                "bash",
                "python",
                "typescript",
                "jsdoc",
                "javascript",
                "tsx",
                "go",
                "glimmer",
                "pug",
                "prisma",
                "rust",
            },
            ignore_install = { "" },
            sync_install = false,
            highlight = {
                enable = true,
                use_languagetree = true,
                disable = function()
                    return vim.b.large_buf
                end,
            },
            indent = {
                enable = false,
                disable = { "python", "css", "rust" },
            },
            autotag = {
                enable = true,
                filetypes = {
                    "html",
                    "javascript",
                    "typescript",
                    "javascriptreact",
                    "typescriptreact",
                    "svelte",
                    "vue",
                    "tsx",
                    "jsx",
                    "rescript",
                    "css",
                    "lua",
                    "xml",
                    "php",
                    "markdown",
                    "go",
                    "rust",
                    "glimmer",
                    "handlebars",
                    "hbs",
                },
            },
            -- context_commentstring = {
            --     enable = true,
            --     enable_autocmd = false,
            -- },
        }
    end,
}
