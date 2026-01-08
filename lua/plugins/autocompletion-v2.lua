return {

    {
        "saghen/blink.cmp",
        -- use a release tag to download pre-built binaries
        version = "1.*",
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        opts_extend = { "sources.default" },
        opts = function()
            ---@module 'blink.cmp'
            ---@type blink.cmp.Config
            return {
                -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
                -- 'super-tab' for mappings similar to vscode (tab to accept)
                -- 'enter' for enter to accept
                -- 'none' for no mappings
                --
                -- All presets have the following mappings:
                -- C-space: Open menu or open docs if already open
                -- C-n/C-p or Up/Down: Select next/previous item
                -- C-e: Hide menu
                -- C-k: Toggle signature help (if signature.enabled = true)
                --
                -- See :h blink-cmp-config-keymap for defining your own keymap

                keymap = {
                    -- we will define ourselves
                    preset = "none",

                    -- Insert mode
                    ["<C-j>"] = { "select_next", "fallback" },
                    ["<C-k>"] = { "select_prev", "fallback" },
                    ["<CR>"] = { "accept", "fallback" },
                    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },

                    -- Docs scrolling
                    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                    ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                    -- Snippets
                    ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
                    ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
                },

                cmdline = {
                    enabled = true,

                    keymap = {
                        preset = "cmdline",
                        ["<C-j>"] = { "select_next", "fallback" },
                        ["<C-k>"] = { "select_prev", "fallback" },
                        -- ["<CR>"] = { "accept_and_enter", "fallback" },
                    },

                    sources = function()
                        local t = vim.fn.getcmdtype()
                        if t == ":" or t == "@" then
                            return { "cmdline", "path", "buffer" }
                        end
                        if t == "/" or t == "?" then
                            return { "buffer" }
                        end
                        return {}
                    end,

                    completion = {
                        list = {
                            selection = {
                                preselect = false,
                                auto_insert = false,
                            },
                        },
                        menu = {
                            auto_show = function()
                                return vim.fn.getcmdtype() == ":"
                            end,
                        },
                    },
                },

                appearance = {
                    nerd_font_variant = "mono",
                },

                -- (Default) Only show the documentation popup when manually triggered
                completion = {
                    -- accept = {
                    --     auto_brackets = { enabled = true },
                    -- },
                    documentation = {
                        auto_show = true,
                        auto_show_delay_ms = 250,
                        treesitter_highlighting = true,
                        window = { border = "rounded" },
                    },
                    trigger = { show_on_keyword = true },
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = true,
                        },
                    },
                },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                sources = {
                    default = { "lsp", "path", "snippets", "buffer" },
                },

                -- snippets = {
                --     preset = "luasnip",
                -- },

                signature = { enabled = true },

                -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
                -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
                -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
                --
                -- See the fuzzy documentation for more information
                fuzzy = { implementation = "prefer_rust_with_warning" },
            }
        end,
    },
}
