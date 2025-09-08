return {

    {
        "windwp/nvim-autopairs",
        lazy = false,
        opts = function()
            return {
                check_ts = true, -- treesitter integration
                disable_filetype = { "TelescopePrompt" },
                ts_config = {
                    lua = { "string", "source" },
                    javascript = { "string", "template_string" },
                    java = false,
                },

                fast_wrap = {
                    map = "<M-e>",
                    chars = { "{", "[", "(", '"', "'" },
                    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
                    offset = 0, -- Offset from pattern match
                    end_key = "$",
                    keys = "qwertyuiopzxcvbnmasdfghjkl",
                    check_comma = true,
                    highlight = "PmenuSel",
                    highlight_grey = "LineNr",
                },
            }
        end,
        config = function(_, opts)
            local status_ok, autopairs = pcall(require, "nvim-autopairs")
            if not status_ok then
                return
            end
            autopairs.setup(opts)
        end,
    },

    {
        "windwp/nvim-ts-autotag",
        lazy = false,
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
    },

    {
        "numToStr/Comment.nvim",
        lazy = true,
        config = function(_, opts)
            local comment = require "Comment"

            comment.setup {
                pre_hook = function(ctx)
                    -- Only calculate commentstring for js/tsx/jsx filetypes for reactjs
                    if
                        vim.bo.filetype == "typescriptreact"
                        or vim.bo.filetype == "javascriptreact"
                        or vim.bo.filetype == "javascript"
                    then
                        local U = require "Comment.utils"

                        -- Determine whether to use linewise or blockwise commentstring
                        local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

                        -- Determine the location where to calculate commentstring from
                        local location = nil
                        if ctx.ctype == U.ctype.blockwise then
                            location = require("ts_context_commentstring.utils").get_cursor_location()
                        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                            location = require("ts_context_commentstring.utils").get_visual_start_location()
                        end

                        return require("ts_context_commentstring.internal").calculate_commentstring {
                            key = type,
                            location = location,
                        }
                    end
                end,
            }
        end,
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        config = function(_, opts)
            require("ibl").setup {}
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",

        config = function(_, opts)
            local lualine = require "lualine"

            local hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end

            local diagnostics = {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                sections = { "error", "warn" },
                symbols = { error = " ", warn = " " },
                colored = false,
                always_visible = true,
            }

            local diff = {
                "diff",
                colored = false,
                symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
                cond = hide_in_width,
            }

            local filetype = {
                "filetype",
                icons_enabled = false,
            }

            local location = {
                "location",
                padding = 0,
            }

            local spaces = function()
                return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
            end

            lualine.setup {
                options = {
                    globalstatus = true,
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = { "alpha", "dashboard" },
                    always_divide_middle = true,
                },
                sections = {
                    lualine_a = { "mode", "branch" },
                    lualine_b = { "filename" },
                    lualine_c = { diagnostics },
                    lualine_x = { diff, spaces, "encoding", filetype },
                    lualine_y = { location },
                    lualine_z = { "progress" },
                },
            }
        end,
    },

    {
        "mbbill/undotree",
        event = "VeryLazy",
    },
}
