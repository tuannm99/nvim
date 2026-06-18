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

local codelldb_root = vim.fn.expand "$MASON/packages/codelldb" .. "/extension/"
local codelldb_path = codelldb_root .. "adapter/codelldb"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb_path,
        args = {
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
