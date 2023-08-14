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

  -- colors = {
  --   bg = "#282A36",
  --   fg = "#F8F8F2",
  --   selection = "#44475A",
  --   comment = "#6272A4",
  --   red = "#FF5555",
  --   orange = "#FFB86C",
  --   yellow = "#F1FA8C",
  --   green = "#50fa7b",
  --   purple = "#BD93F9",
  --   cyan = "#8BE9FD",
  --   pink = "#FF79C6",
  --   bright_red = "#FF6E6E",
  --   bright_green = "#69FF94",
  --   bright_yellow = "#FFFFA5",
  --   bright_blue = "#D6ACFF",
  --   bright_magenta = "#FF92DF",
  --   bright_cyan = "#A4FFFF",
  --   bright_white = "#FFFFFF",
  --   menu = "#21222C",
  --   visual = "#3E4452",
  --   gutter_fg = "#4B5263",
  --   nontext = "#3B4048",
  --   white = "#ABB2BF",
  --   black = "#191A21",
  -- },

vim.cmd [[
function MyCustomHighlights()
    hi semshiLocal           ctermfg=209 guifg=#ff875f
    hi semshiGlobal          ctermfg=214 guifg=#8BE9FD cterm=bold
    hi semshiImported        ctermfg=214 guifg=#8BE9FD cterm=bold gui=bold
    hi semshiParameter       ctermfg=75  guifg=#5fafff
    hi semshiParameterUnused ctermfg=117 guifg=#87d7ff cterm=underline gui=underline
    hi semshiFree            ctermfg=218 guifg=#ffafd7
    hi semshiBuiltin         ctermfg=207 guifg=#ff5fff
    hi semshiAttribute       ctermfg=49  guifg=#00ffaf
    hi semshiSelf            ctermfg=249 guifg=#b2b2b2
    hi semshiUnresolved      ctermfg=226 guifg=#ffff00 cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#FF79C6

    hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    sign define semshiError text=E> texthl=semshiErrorSignendfunction
endfunction
autocmd FileType python call MyCustomHighlights()
autocmd ColorScheme * call MyCustomHighlights()
]]
