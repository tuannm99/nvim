return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            branch = "main",
        },
    },
    -- event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    priority = 500,
    config = function(_, opts)
        local treesitter = require "nvim-treesitter"

        treesitter.setup(opts)

        treesitter.install {
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
            -- "sql",
            "proto",
            "toml",
            "templ",
            "c",
        }

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
            callback = function()
                local ok = pcall(vim.treesitter.start)
                if ok then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end,
        })
    end,
}
