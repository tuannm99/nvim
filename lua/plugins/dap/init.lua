return {
    {
        "mfussenegger/nvim-dap",
        lazy = true,
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
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require "plugins.dap.ui"
        end,
    },

    {
        "mfussenegger/nvim-dap-python",
        lazy = true,
    },

    {
        "leoluz/nvim-dap-go",
        lazy = true,
        dependencies = { "mfussenegger/nvim-dap" },
        -- build = "go install github.com/go-delve/delve/cmd/dlv"
        -- export PATH="$PATH:$(go env GOPATH)/bin"
    },
}
