local dap = require "dap"

-- python debug
local function get_venv()
    local cwd = vim.fn.getcwd()
    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
        return cwd .. "/venv/bin/python"
    elseif vim.fn.executable(cwd .. "/venv/bin/python2") == 1 then
        return cwd .. "/venv/bin/python2"
    elseif vim.fn.executable(cwd .. "/venv/bin/python3") == 1 then
        return cwd .. "/venv/bin/python3"
    else
        return "/usr/bin/python3"
    end
end
require("dap-python").setup(get_venv())

-- js/ts debug
require("dap-vscode-js").setup {
    debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
    adapters = {
        "chrome",
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "node-terminal",
        "pwa-extensionHost",
        "node",
        "chrome",
    },
    -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
    -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
    -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
}

-- local js_based_languages = { "typescript", "javascript", "typescriptreact" }
dap.configurations["javascript"] = {
    {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
    },
}

dap.configurations["typescript"] = {
    { -- work on nestjs project
        type = "pwa-node",
        request = "launch",
        name = "NestJS: Launch",
        -- program = "${file}",
        cwd = "${workspaceFolder}",
        skipFiles = {
            "<node_internals>/**",
        },
        sourceMaps = true,
        resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
        },
        protocol = "inspector",
        console = "integratedTerminal",

        runtimeExecutable = "nest",
        args = { "start", "--debug", "--watch" },
    },
    {
        type = "pwa-node",
        request = "launch",
        name = "ts-node - /dist source",
        program = "${file}", -- or "${workspaceFolder}/src/index.js",
        cwd = "${workspaceFolder}",
        protocol = "inspector",
        console = "integratedTerminal",
        outFiles = { "${workspaceFolder}/dist/**/*.js" },
        runtimeExecutable = "ts-node",
    },
}

-- go debug
require("dap-go").setup {
    delve = {
        path = "dlv",
        initialize_timeout_sec = 20,
        port = "${port}",
        args = { "--log", "--log-output=stdout" },
        build_flags = {},
        detached = false,
        cwd = nil,
    },
    tests = {
        verbose = true,
    },
}

-- rust debug
local mason_registry = require "mason-registry"
-- local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
local codelldb_root = vim.fn.expand "$MASON/packages/codelldb" .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"
-- local liblldb_path = codelldb_root .. "lldb/lib/liblldb.so"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb_path,
        args = {
            -- "--liblldb",
            -- liblldb_path,
            "--port",
            "${port}",
        },
    },
}
dap.configurations.rust = {
    {
        name = "Rust debug",
        type = "codelldb",
        request = "launch",
        program = function()
            vim.fn.jobstart "cargo build"
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
    },
    {
        name = "Rust debug current",
        type = "codelldb",
        request = "launch",
        program = function()
            vim.fn.jobstart "cargo build"
            local cargo_toml = vim.fn.getcwd() .. "/Cargo.toml"
            local project_name = vim.fn.system("basename " .. vim.fn.fnamemodify(cargo_toml, ":h"))
            return vim.fn.getcwd() .. "/target/debug/" .. vim.fn.trim(project_name)
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true,
    },
}
