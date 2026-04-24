return {
    {
        dir = "/home/minhtuan/dev/local/muxwf/nvim",
        name = "muxwf.nvim",
        lazy = false,
        config = function()
            vim.g.muxwf_bin = vim.fn.expand("~/.local/bin/mw")
            vim.g.muxwf_default_mappings = 1
        end,
    },
}
