local M = {}

local status_cmp_ok, blink_cmp_lsp = pcall(require, "blink.cmp")
if not status_cmp_ok then
    return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = blink_cmp_lsp.get_lsp_capabilities(M.capabilities)

M.setup = function()
    vim.diagnostic.config {
        virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
        float = { border = "rounded", source = true },

        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN] = "",
                [vim.diagnostic.severity.HINT] = "",
                [vim.diagnostic.severity.INFO] = "",
            },
        },

        underline = { severity = { min = vim.diagnostic.severity.WARN } },
        update_in_insert = false,
        severity_sort = true,
    }
end

vim.api.nvim_create_user_command("GoToDefinitionOrTypeDefinition", function()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    local has_definition_provider = false

    for _, client in ipairs(clients) do
        if client.server_capabilities.definitionProvider then
            has_definition_provider = true
            break
        end
    end

    if has_definition_provider then
        -- Try to go to definition first
        local params = vim.lsp.util.make_position_params(0, "utf-8")
        local definition_result = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 1000)

        local has_definition = false

        if definition_result then
            for _, res in pairs(definition_result) do
                if res.result and #res.result > 0 then
                    has_definition = true
                    -- Use Lspsaga for goto_definition
                    vim.cmd "Lspsaga goto_definition"
                    break
                end
            end
        end

        -- If no definition found, try to go to type definition
        if not has_definition then
            vim.cmd "Lspsaga goto_type_definition"
        end
    else
        -- Fallback to type definition directly
        vim.cmd "Lspsaga goto_type_definition"
    end
end, {})

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    -- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- keymap(bufnr, "n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- keymap(bufnr, "n", "<leader>lsa", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    -- keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

    keymap(bufnr, "n", "gD", "<cmd>Lspsaga goto_type_definition<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>GoToDefinitionOrTypeDefinition<CR>", opts)
    -- keymap(bufnr, "n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
    -- keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- keymap(bufnr, "n", "gr", "<cmd>Lspsaga peek_definition<CR>", opts)
    keymap(bufnr, "n", "ge", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
    -- keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
    keymap(bufnr, "n", "<leader>lsa", "<cmd>Lspsaga code_action<cr>", opts)
    keymap(bufnr, "n", "<leader>lr", "<cmd>Lspsaga rename<cr>", opts)
    keymap(bufnr, "n", "<leader>lso", "<cmd>Lspsaga outline<cr>", opts)
    keymap(bufnr, "n", "<leader>lsf", "<cmd>Lspsaga finder<cr>", opts)
end

M.on_attach = function(client, bufnr)
    if client.name == "tsserver" then
        client.server_capabilities.documentFormattingProvider = false
    end

    if client.name == "sumneko_lua" then
        client.server_capabilities.documentFormattingProvider = false
    end

    if client.name == "pyright" then
        client.server_capabilities.documentFormattingProvider = false
    end

    lsp_keymaps(bufnr)
    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        return
    end
    illuminate.on_attach(client)
end

return M
