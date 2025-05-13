require("mason").setup {
    pip = {
        upgrade_pip = true,
    },
    ui = {
        border = "none",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
}

local servers = {
    "prismals",
    "gopls",
    "golangci_lint_ls",
    "rust_analyzer",
    "cssls",
    "html",
    "pyright",
    "bashls",
    "jsonls",
    "yamlls",
    "emmet_ls",
    "eslint",
    "lua_ls",
    "tailwindcss",
    "sqlls",
    "ts_ls",
    "angularls",
    "templ",
}
require("mason-lspconfig").setup {
    ensure_installed = servers,
    automatic_installation = true,
}

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
    return
end

local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = require("plugins.lsp.handlers").on_attach,
        capabilities = require("plugins.lsp.handlers").capabilities,
    }

    server = vim.split(server, "@")[1]

    local require_ok, conf_opts = pcall(require, "plugins.lsp.settings." .. server)
    if require_ok then
        opts = vim.tbl_deep_extend("force", conf_opts, opts)
    end

    lspconfig[server].setup(opts)
end

-- !!!! SUPORTING PYTHON2 (hover, go-to-implement, cmp for reading old projects -_-)
-- python2 -m virtualenv venv
-- . venv/bin/activate
-- REQUIREMENTS for venv -> pip install python-language-server autopep8 pynvim neovim debugpy
-- this only work when existed virtualenv on python2 (with this very old package installed) -> python-language-server
-- we are should using both pyright and pyls but the linter for python3 (pyright) is very annoying
local venv_pylsp_path = vim.fn.getcwd() .. "/venv/bin/pyls"
if vim.fn.filereadable(venv_pylsp_path) == 1 then
    -- pylsp is a fork of pyls, note that the venv path is saved as name `pyls`
    -- but nvimlsp-server is `pylsp`
    lspconfig.pylsp.setup {
        cmd = { venv_pylsp_path },
        on_attach = require("plugins.lsp.handlers").on_attach,
        capabilities = require("plugins.lsp.handlers").capabilities,
        settings = {
            python = {
                analysis = {
                    extraPaths = { "./", "./common_lib" },
                },
            },
        },
    }
else
    -- disable pyright because it can't understand python2
    lspconfig.pyright = nil
end
