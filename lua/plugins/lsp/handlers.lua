local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
    local signs = {

        { name = "DiagnosticSignError" },
        { name = "DiagnosticSignWarn" },
        { name = "DiagnosticSignHint" },
        { name = "DiagnosticSignInfo" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        underline = {
            severity = {
                min = vim.diagnostic.severity.INFO,
                max = vim.diagnostic.severity.WARN,
            },
        },
        signs = {
            active = signs, -- show signs
        },
        update_in_insert = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --     virtual_text = {
    --         severity = { min = vim.diagnostic.severity.ERROR },
    --     }
    -- })
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    -- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- keymap(bufnr, "n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    -- keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- keymap(bufnr, "n", "<leader>lsa", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    -- keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

    keymap(bufnr, "n", "gD", "<cmd>Lspsaga goto_type_definition<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
    -- keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "gr", "<cmd>Lspsaga peek_definition<CR>", opts)
    keymap(bufnr, "n", "ge", "<cmd>Lspsaga show_cursor_diagnostic<CR>", opts)
    keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
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
