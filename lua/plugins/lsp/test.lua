local neotest_ns = vim.api.nvim_create_namespace "neotest"
vim.diagnostic.config({
    virtual_text = {
        format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
        end,
    },
}, neotest_ns)

require("neotest").setup {
    adapters = {
        require "neotest-python" {
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
            pytest_discover_instances = true,
        },

        require "neotest-go" {
            experimental = {
                test_table = true,
            },
            recursive_run = true,
            -- args = { "-count=1", "-timeout=60s" },
        },

        require "neotest-rust" {
            args = {},
            dap_adapter = "codelldb",
        },
    },
}
