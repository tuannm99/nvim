local rust_tools = {}

function rust_tools.setup()
    vim.g.rustaceanvim = function()
        local mason_registry = require "mason-registry"

        local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
        local codelldb_path = codelldb_root .. "adapter/codelldb"
        local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

        local cfg = require "rustaceanvim.config"

        return {
            dap = {
                adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
            },
            inlay_hints = {
                highlight = "NonText",
            },
            tools = {
                hover_actions = {
                    auto_focus = true,
                },
                enable_clippy = true,
            },
            server = {
                on_attach = require("plugins.lsp.handlers").on_attach,
                default_settings = {
                    ["rust-analyzer"] = {
                        imports = {
                            granularity = {
                                group = "module",
                            },
                            prefix = "self",
                        },
                        cargo = {
                            buildScripts = {
                                enable = true,
                            },
                        },
                        procMacro = {
                            enable = true,
                        },
                        diagnostics = {
                            experimental = {
                                enable = true,
                            },
                        },
                    },
                },
            },
        }
    end
end

return rust_tools
