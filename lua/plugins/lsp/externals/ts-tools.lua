local api = require "typescript-tools.api"

local status_ok, illuminate = pcall(require, "illuminate")
if not status_ok then
    return
end

require("typescript-tools").setup {
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- illuminate.on_attach(client)
        require("plugins.lsp.handlers").on_attach(client, bufnr)
    end,

    settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_plugins = {},
        tsserver_max_memory = 3072,
        tsserver_format_options = {},
        tsserver_file_preferences = {
            quotePreference = "auto",
            displayPartsForJSDoc = true,
            disableLineTextInReferences = false,

            -- Inlay Hints
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeInlayEnumMemberValueHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayVariableTypeHints = false,
        },
        tsserver_locale = "en",
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = "all",
        disable_member_code_lens = true,
        jsx_close_tag = {
            enable = false,
            filetypes = { "javascript", "javascriptreact", "typescriptreact" },
        },
    },
}
