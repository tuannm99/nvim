return {
    settings = {
        gopls = {
            gofumpt = true,
            analyses = {
                composites = false,
            },
            directoryFilters = {
                "-.git",
                "-node_modules",
                "-vendor",
                "-build",
                "-dist",
                "-mock-generated-codes",
            },
            staticcheck = false,
            semanticTokens = false,
        },
    },
    flags = {
        debounce_text_changes = 500,
    },
}
