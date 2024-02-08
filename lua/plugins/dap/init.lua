return {
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        dependencies = {
            "ravenxrz/DAPInstall.nvim",
        },
        config = function()
            require "plugins.dap.handlers"
        end,
    },

    {
        "theHamsta/nvim-dap-virtual-text",

        lazy = true,
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require "plugins.dap.virtual-text"
        end,
    },

    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy", -- for debuggin icon
        dependencies = { "mfussenegger/nvim-dap" },
        config = function()
            require "plugins.dap.ui"
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        lazy = true,
    },

    {
        "mxsdev/nvim-dap-vscode-js",
        lazy = true,
        dependencies = { "mfussenegger/nvim-dap" },
    },

    {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
}
