local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then
  return
end

local dap_virtual_text_ok, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")
if not dap_virtual_text_ok then
  return
end

local dbg_path = require("dap-install.config.settings").options["installation_path"]

dap_virtual_text.setup {
  enabled = true,
  enabled_commands = true,
  highlight_changed_variables = true,
  highlight_new_as_changed = false,
  show_stop_reason = true,
  commented = false,
  only_first_definition = true,
  all_references = false,
  display_callback = function(variable, _buf, _stackframe, _node)
    return variable.name .. ' = ' .. variable.value
  end,

  virt_text_pos = 'eol',
  all_frames = false,
  virt_lines = false,
  virt_text_win_col = nil
}

-- run DIInstall jsnode + chrome; if need more check out documentation,
-- if dap_install not provide adapter that needed so need to download adapter and map args adapters by hand
dap_install.setup {}
dap_install.config("python", {})
-- dap_install.config("jsnode", {})
-- nodejs
dap.adapters["pwa-node"] = {
  type = "executable",
  command = "node",
  args = { dbg_path .. "jsnode/vscode-node-debug2/out/src/nodeDebug.js", "${port}" },
}
dap.adapters["chrome"] = {
  type = "executable",
  command = "node",
  args = { dbg_path .. "chrome/vscode-chrome-debug/out/src/chromeDebug.js", "${port}" },
}

-- TODO: update typesript configuration + add more language adapter such us python, golang ...
local adapter_configs = {
  node = {
    javascript = {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = 'inspector',
      console = 'integratedTerminal'
    },
    typescript = {
      type = "pwa-node",
      request = 'launch',
      name = 'Debug',
      program = '${workspaceFolder}/dist/app.js',
      sourceMaps = true,
      protocol = 'inspector',
      cwd = vim.fn.getcwd(),
      runtimeArgs = { '--nolazy' },
      console = 'integratedTerminal',
    }
  },
  chrome = {
    javascript = {
      type = "chrome",
      request = "launch",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      url = 'http://localhost:3000',
      webRoot = "${workspaceFolder}/public"
    },
    typescript = {
      type = "chrome",
      request = "launch",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      port = 9222,
      url = 'http://localhost:3000',
      webRoot = "${workspaceFolder}/public"
    }
  },
}

local function choose_config()
  local _configs = { "node", "chrome" }
  local choice = vim.fn.inputlist({
    "1: node",
    "2: chrome",
  })

  if choice == 0 or choice > #_configs then
    return nil
  end

  local adapter = _configs[choice]
  if choice == 1 or choice == 2 then
    local language = { "javascript", "typescript" }
    local language_choice = vim.fn.inputlist({
      "\n1: javascript",
      "2: typescript",
    })
    local chosen_language = language[language_choice]
    adapter = adapter_configs[adapter][chosen_language]
  end

  return adapter
end

-- this global func run when start debuging; required to choose configuration: node, chrome, etc,...
function Start_debugging()
  local config = choose_config()
  if not config then
    print("No configuration selected")
    return
  end
  local success, result = pcall(function()
    dap.run(config)
  end)
  if not success then
    print("Failed to start debugging: " .. result)
  end
end

dapui.setup {
  expand_lines = true,
  icons = { expanded = "", collapsed = "", circular = "" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
        { id = "scopes",      size = 0.33 },
        { id = "breakpoints", size = 0.17 },
        { id = "stacks",      size = 0.25 },
        { id = "watches",     size = 0.25 },
      },
      size = 0.33,
      position = "right",
    },
    {
      elements = {
        { id = "repl",    size = 0.45 },
        { id = "console", size = 0.55 },
      },
      size = 0.27,
      position = "bottom",
    },
  },
  floating = {
    max_height = 0.9,
    max_width = 0.5,             -- Floats will be treated as percentage of your screen.
    border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
