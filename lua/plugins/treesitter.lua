return {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    build = ":TSUpdate",
    priority = 500,
    config = function(_, opts)
        require("nvim-treesitter.install").prefer_git = true
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
                "terraform",
                "sql",
                "proto",
                "toml",
                "templ",
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
                enable = true,
                -- disable = { "python", "css", "rust" },
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
                    "templ",
                },
            },
        }
    end,
}
