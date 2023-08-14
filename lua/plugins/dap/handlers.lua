local dap = require "dap"

-- python
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

require("dap-vscode-js").setup {
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = "/home/minhtuan/.config/nvim/vscode-js-debug",                                                           -- Path to vscode-js-debug installation.
    -- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
    adapters = {
        "chrome",
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "node-terminal",
        "pwa-extensionHost",
        "node",
        "chrome",
    }, -- which adapters to register in nvim-dap
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
        -- port = 3000,
        -- env = {
        --     NODE_ENV = "dev",
        -- },
        -- outFiles = {
        --     "${workspaceFolder}/dist/main.js",
        -- },
        -- sourceMapPathOverrides = {
        --     ["webpack:///./src/*"] = "${workspaceFolder}/src/*",
        --     ["webpack:///src/*"] = "${workspaceFolder}/src/*",
        --     ["webpack:///*"] = "*",
        -- }
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
