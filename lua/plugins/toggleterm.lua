return {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    opts = function()
        return {
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "float",
            close_on_exit = true,
            shell = vim.o.shell,
            float_opts = {
                border = "curved",
            },
        }
    end,
    config = function(_, opts)
        require("toggleterm").setup(opts)

        local function set_terminal_keymaps()
            local terminal_opts = { buffer = true, noremap = true }
            vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-W>h]], terminal_opts)
            vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-W>j]], terminal_opts)
            vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-W>k]], terminal_opts)
            vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-W>l]], terminal_opts)
        end

        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = set_terminal_keymaps,
        })

        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new { cmd = "lazygit", hidden = true }

        function _LAZYGIT_TOGGLE()
            lazygit:toggle()
        end
    end,
}
