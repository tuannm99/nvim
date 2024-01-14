require("sonarlint").setup {
    server = {
        cmd = {
            "sonarlint-language-server",
            -- Ensure that sonarlint-language-server uses stdio channel
            "-stdio",
            "-analyzers",
            -- paths to the analyzers you need, using those for python and java in this example
            vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarpython.jar",
            vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarcfamily.jar",
            vim.fn.expand "$MASON/share/sonarlint-analyzers/sonarjava.jar",
        },

        -- All settings are optional
        settings = {
            -- sonarlint = {
            --     rules = {
            --         ['typescript:S101'] = { level = 'on', parameters = { format = '^[A-Z][a-zA-Z0-9]*$' } },
            --         ['typescript:S103'] = { level = 'on', parameters = { maximumLineLength = 180 } },
            --         ['typescript:S106'] = { level = 'on' },
            --         ['typescript:S107'] = { level = 'on', parameters = { maximumFunctionParameters = 7 } }
            --     }
            -- }
        },
    },
    filetypes = {
        "typescript",
        "javascript",
        "jsx",
        "tsx",
        "python",
        "cpp",
        -- Requires nvim-jdtls, otherwise an error message will be printed
        -- 'java',
    },
}
