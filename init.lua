require "user.impatient"
require "user.options"
require "user.plugins"
require "user.autocommands"
require "user.colorscheme"
require "user.cmp"
require "user.telescope"
require "user.gitsigns"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.nvim-tree"
require "user.lualine"
require "user.toggleterm"
require "user.project"
require "user.illuminate"
require "user.indentline"
require "user.lsp"
require "user.dap"
require "user.filetype"
require "user.keymaps"
require "user.tmux-navigation"
-- require("venv-selector").setup({})

-- Define the path to your virtual environment
local venv_path = vim.fn.getcwd() .. '/venv'

-- Check if a virtual environment exists in the current directory
if vim.fn.isdirectory(venv_path) == 1 then
  -- Activate the virtual environment
  vim.env.VIRTUAL_ENV = venv_path
  vim.env.PATH = venv_path .. '/bin:' .. vim.env.PATH

  -- Use the Python executable in the virtual environment
  vim.g.python3_host_prog = venv_path .. '/bin/python3'

  -- Add the virtual environment's site-packages folder to the Python path
  local site_packages = vim.fn.glob(venv_path .. '/lib/python*/site-packages')
  if vim.fn.empty(site_packages) == 0 then
    vim.g.python3_host_extra_paths = {site_packages}
  end
end
