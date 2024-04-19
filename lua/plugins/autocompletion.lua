return {
    { "saadparwaiz1/cmp_luasnip" },

    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        event = "VeryLazy",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load {}
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        lazy = true,
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lua" },
        },
        config = function()
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if not cmp_status_ok then
                return
            end

            local snip_status_ok, luasnip = pcall(require, "luasnip")
            if not snip_status_ok then
                return
            end

            local check_backspace = function()
                local col = vim.fn.col "." - 1
                return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
            end

            local lspkind_comparator = function(conf)
                local lsp_types = require("cmp.types").lsp
                return function(entry1, entry2)
                    if entry1.source.name ~= "nvim_lsp" then
                        if entry2.source.name == "nvim_lsp" then
                            return false
                        else
                            return nil
                        end
                    end
                    local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
                    local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

                    local priority1 = conf.kind_priority[kind1] or 0
                    local priority2 = conf.kind_priority[kind2] or 0
                    if priority1 == priority2 then
                        return nil
                    end
                    return priority2 < priority1
                end
            end

            local label_comparator = function(entry1, entry2)
                return entry1.completion_item.label < entry2.completion_item.label
            end

            local kind_icons = {
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
            }

            cmp.setup {
                enabled = function()
                    return not vim.b.large_buf
                end,
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body) -- For `luasnip` minhtuans.
                    end,
                },
                sorting = {
                    comparators = {
                        lspkind_comparator {
                            kind_priority = {
                                Field = 11,
                                Property = 11,
                                Constant = 10,
                                Enum = 10,
                                EnumMember = 10,
                                Event = 10,
                                Function = 10,
                                Method = 10,
                                Operator = 10,
                                Reference = 10,
                                Struct = 10,
                                Variable = 9,
                                File = 8,
                                Folder = 8,
                                Class = 5,
                                Color = 5,
                                Module = 5,
                                Keyword = 2,
                                Constructor = 1,
                                Interface = 1,
                                Snippet = 0,
                                Text = 1,
                                TypeParameter = 1,
                                Unit = 1,
                                Value = 1,
                            },
                        },
                        label_comparator,
                    },
                },

                mapping = cmp.mapping.preset.insert {
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-e>"] = cmp.mapping {
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    },
                    -- Accept currently selected item. If none selected, `select` first item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ["<CR>"] = cmp.mapping.confirm { select = true },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif check_backspace() then
                            fallback()
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        vim_item.kind = kind_icons[vim_item.kind]
                        vim_item.menu = ({
                            nvim_lsp = "",
                            nvim_lua = "",
                            luasnip = "",
                            buffer = "",
                            path = "",
                            emoji = "",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                sources = {
                    { name = "nvim_lsp" },
                    { name = "nvim_lua" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                experimental = {
                    ghost_text = true,
                },
            }
        end,
    },
}
