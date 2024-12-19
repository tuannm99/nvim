return {
    {
        "j-hui/fidget.nvim",
        tag = "v1.2.0",
        lazy = false,
        config = function()
            require("fidget").setup {}
        end,
    },

    {
        "williamboman/mason.nvim",
        lazy = false,
        build = ":MasonUpdate",
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        config = function()
            require "plugins.lsp.mason"
        end,
    },

    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        lazy = false,
        init_options = {
            userLanguages = {
                eelixir = "html-eex",
                eruby = "erb",
                rust = "html",
            },
        },
        config = function()
            require("plugins.lsp.handlers").setup()
        end,
    },

    {
        "nvimdev/lspsaga.nvim",
        -- commit = "3112b7aba57653199ad20198f477d94781bb2310",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup {}
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },

    {
        "nvimtools/none-ls.nvim",
        event = "LspAttach",
        commit = "de747e01f732fbb9e48d3b87a7653c633835c9e7",
        config = function()
            local null_ls_status_ok, null_ls = pcall(require, "null-ls")
            if not null_ls_status_ok then
                return
            end

            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics

            local function is_file_exists(filename)
                local file = io.open(filename, "r")
                if file then
                    file:close()
                    return true
                end
                return false
            end

            local function should_config_eslint()
                if is_file_exists ".eslintrc" or is_file_exists ".eslintrc.json" or is_file_exists ".eslintrc.js" then
                    return true
                end
                return false
            end

            local function prettier()
                if
                    is_file_exists ".prettierrc"
                    or is_file_exists ".prettierrc.json"
                    or is_file_exists ".prettierrc.js"
                    or is_file_exists ".prettierrc"
                then
                    -- use default
                    return formatting.prettier
                end
                return formatting.prettier.with {
                    extra_args = {
                        "--single-quote",
                        "--no-semi",
                        "--tab-width=2",
                        "--print-width=80",
                        "--bracket-spacing=false",
                        "--trailing-comma=none",
                    },
                }
            end

            local sources = {
                formatting.autopep8.with { extra_args = { "--max-line-length", "120", "--experimental" } },
                formatting.stylua.with {},
                formatting.sql_formatter.with {},
            }

            if should_config_eslint() then
                table.insert(sources, diagnostics.eslint.with { method = null_ls.methods.DIAGNOSTICS_ON_SAVE })
            end
            table.insert(sources, prettier())

            null_ls.setup {
                debug = false,
                sources = sources,
            }
        end,
    },

    {
        "RRethy/vim-illuminate",
        lazy = true,
        config = function()
            local status_ok, illuminate = pcall(require, "illuminate")
            if not status_ok then
                return
            end

            vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
            vim.api.nvim_set_keymap(
                "n",
                "<a-n>",
                '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
                { noremap = true }
            )
            vim.api.nvim_set_keymap(
                "n",
                "<a-p>",
                '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
                { noremap = true }
            )

            illuminate.configure {
                providers = {
                    "lsp",
                    "treesitter",
                    "regex",
                },
                delay = 200,
                filetypes_denylist = {
                    "dirvish",
                    "fugitive",
                    "alpha",
                    "NvimTree",
                    "packer",
                    "neogitstatus",
                    "Trouble",
                    "lir",
                    "Outline",
                    "spectre_panel",
                    "toggleterm",
                    "DressingSelect",
                    "TelescopePrompt",
                },
                filetypes_allowlist = {},
                modes_denylist = {},
                modes_allowlist = {},
                providers_regex_syntax_denylist = {},
                providers_regex_syntax_allowlist = {},
                under_cursor = true,
            }
        end,
    },

    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-python",
            "rouge8/neotest-rust",
        },
        config = function()
            require "plugins.lsp.test"
        end,
    },

    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                -- { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },

    -- {
    --     "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    --     lazy = false,
    --     config = function()
    --         require "plugins.lsp.externals.sonarlint"
    --     end,
    -- },

    -- {
    --     "pmizio/typescript-tools.nvim",
    --     event = "VeryLazy",
    --     config = function()
    --         require "plugins.lsp.externals.ts-tools"
    --     end,
    -- },
}
