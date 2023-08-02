-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

keymap("", "q", "<Nop>", opts)
keymap("n", "<c-z>", "<nop>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<leader>q", "<cmd>Bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --

keymap("n", "<C-n>", ":NvimTreeToggle<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fl", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- dap
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dd", "<cmd>lua require'dap'.clear_breakpoints()<cr>", opts)
keymap("n", "<leader>ds", "<cmd>lua Start_debugging()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)

keymap("n", "<leader>dwh", "<cmd>lua require'dap.ui.widgets'.hover()<cr>", opts)
keymap("n", "<leader>dwp", "<cmd>lua require'dap.ui.widgets'.preview()<cr>", opts)
-- keymap("n", "<leader>dv", "<cmd>lua require'dap.ui.variables'.visual_hover()<cr>", opts)
keymap(
  "n",
  "<leader>dwc",
  "<cmd>lua local widgets = require'dap.ui.widgets'; widgets.centered_float(widgets.scopes)<cr>",
  opts
)
keymap(
  "n",
  "<leader>dwf",
  "<cmd>lua local widgets = require'dap.ui.widgets'; widgets.centered_float(widgets.frames)<cr>",
  opts
)

keymap("n", "<leader>fdc", ":Telescope dap commands<cr>", opts)
keymap("n", "<leader>fdf", ":Telescope dap frames <cr>", opts)
keymap("n", "<leader>fdb", ":Telescope dap list_breakpoints <cr>", opts)
keymap("n", "<leader>fdv", ":Telescope dap variables <cr>", opts)
keymap("n", "<leader>fdf", ":Telescope dap frames <cr>", opts)

-- Lsp
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
keymap("v", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)

keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
keymap("n", "<leader>m", ":MaximizerToggle<CR>", opts)

-- todo
keymap("n", "<leader>tf", ":TodoQuickFix<cr>", opts)
keymap("n", "<leader>tt", ":TodoTelescope<cr>", opts)

-- custom log
function Custom_log()
  local filetype = vim.bo.filetype
  local allowed_js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "html", "pug" }
  local allowed_python_filetypes = { "python" }

  if vim.tbl_contains(allowed_js_filetypes, filetype) then
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local variable = vim.fn.expand "<cword>"
    local filename = vim.fn.expand "%:t"
    local output = "\nconsole.log('❤❤❤ tuannm: [" .. filename .. "][" .. line .. "][" .. variable .. "]', " .. variable .. ")"
    vim.api.nvim_input(output)
    vim.api.nvim_command "startinsert!"
    vim.api.nvim_input "<Esc>"
  elseif vim.tbl_contains(allowed_python_filetypes, filetype) then
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local variable = vim.fn.expand "<cword>"
    local filename = vim.fn.expand "%:t"
    local output = "\nprint('❤❤❤ tuannm: [" .. filename .. "][" .. line .. "][" .. variable .. "]', " .. variable .. ")"
    vim.api.nvim_input(output)
    vim.api.nvim_command "startinsert!"
    vim.api.nvim_input "<Esc>"
  else
    vim.api.nvim_feedkeys("<C-l>", "n", true)
  end
  -- TODO: add more language
end

keymap("n", "<leader>cl", ":lua Custom_log()<CR>", opts)

-- Define the key mapping function
function FoldToggle()
  -- Check if a fold exists at the current cursor position
  if vim.fn.foldclosed(vim.fn.line ".") ~= -1 then
    -- If a fold exists, toggle the fold under the cursor between folded and unfolded states
    vim.cmd ":normal! za<CR>"
  else
    -- If no fold exists, fold the text from the current cursor position to the matching closing bracket or parenthesis
    vim.cmd ":normal! zf%<CR>"
  end
end

-- Define the key mapping using the foldToggle function
keymap("n", "ff", ":lua FoldToggle()<CR>", opts)

-- harpoon
keymap("n", "<A-m>", ':lua require("harpoon.mark").add_file()<CR>', opts)
keymap("n", "<A-u>", ':lua require("harpoon.ui").toggle_quick_menu()<CR>', opts)
keymap("n", "<A-l>", ':lua require("harpoon.ui").nav_next()<CR>', opts)
keymap("n", "<A-h>", ':lua require("harpoon.ui").nav_prev()<CR>', opts)
