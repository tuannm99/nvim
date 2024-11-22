require("neotest").setup {
    adapters = {
        require "neotest-rust" {
            args = {},
            dap_adapter = "codelldb",
        },
    },
}
