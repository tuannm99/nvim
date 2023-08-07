vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
    callback = function()
        vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
    end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

vim.api.nvim_create_autocmd({ "VimResized" }, {
    callback = function()
        vim.cmd "tabdo wincmd ="
    end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
    callback = function()
        vim.cmd "quit"
    end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    callback = function()
        vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
    end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.java" },
    callback = function()
        vim.lsp.codelens.refresh()
    end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
        vim.cmd "hi link illuminatedWord LspReferenceText"
    end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        local line_count = vim.api.nvim_buf_line_count(0)
        if line_count >= 5000 then
            vim.cmd "IlluminatePauseBuf"
        end
    end,
})

local venv_path = vim.fn.getcwd() .. "/venv"
if vim.fn.isdirectory(venv_path) == 1 then
    -- Activate the virtual environment
    vim.env.VIRTUAL_ENV = venv_path
    vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
    vim.g.python3_host_prog = venv_path .. "/bin/python3"

    local site_packages = vim.fn.glob(venv_path .. "/lib/python*/site-packages")
    if vim.fn.empty(site_packages) == 0 then
        vim.g.python3_host_extra_paths = { site_packages }
    end
end
