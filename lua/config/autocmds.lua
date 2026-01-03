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

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--     pattern = { "*.java" },
--     callback = function()
--         vim.lsp.codelens.refresh()
--     end,
-- })

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

local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    callback = function()
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        if ok and stats and (stats.size > 100000) then
            vim.b.large_buf = true
            -- vim.cmd "syntax off"
            local illuminate_ok, illuminate = pcall(require, "illuminate")
            if illuminate_ok then
                illuminate.pause_buf()
            end
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.spell = false
        else
            vim.b.large_buf = false
        end
    end,
    group = aug,
    pattern = "*",
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

-- indent helpers
local function set_indent(buf, expandtab, size)
    vim.bo[buf].expandtab = expandtab
    vim.bo[buf].tabstop = size
    vim.bo[buf].shiftwidth = size
    vim.bo[buf].softtabstop = size
end

local function set_tabs(buf, tabstop)
    vim.bo[buf].expandtab = false
    vim.bo[buf].tabstop = tabstop or 8
    vim.bo[buf].shiftwidth = 0 -- use tabstop when indenting
    vim.bo[buf].softtabstop = 0
end

local grp = vim.api.nvim_create_augroup("IndentRules", { clear = true })

-- Default for everything: 2 spaces
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    callback = function(args)
        set_indent(args.buf, true, 2)
    end,
})

-- Python: 4 spaces
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    pattern = { "*.py" },
    callback = function(args)
        set_indent(args.buf, true, 4)
    end,
})

-- Go: tabs (gofmt style)
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    pattern = { "*.go" },
    callback = function(args)
        set_tabs(args.buf, 4)
    end,
})

-- rust
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    pattern = { "*.rs" },
    callback = function(args)
        set_tabs(args.buf, 4)
    end,
})

-- Makefile: must be tabs
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    pattern = { "Makefile", "makefile", "GNUmakefile" },
    callback = function(args)
        set_tabs(args.buf, 8)
    end,
})

-- Filename-based (không phụ thuộc extension)
-- Jenkinsfile (Groovy) / Dockerfile: bạn muốn spaces
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = grp,
    pattern = { "Jenkinsfile", "Dockerfile" },
    callback = function(args)
        set_indent(args.buf, true, 2)
    end,
})
