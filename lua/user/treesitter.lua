local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
    return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup {
    ensure_installed = { "vue", "html", "lua", "markdown", "markdown_inline", "bash", "python", "typescript",
        "jsdoc", "javascript", "tsx", "go", "glimmer", "pug", "prisma" },
    ignore_install = { "" },
    sync_install = false,

    highlight = {
        enable = true,
        use_languagetree = true,
        disable = {},
    },
    indent = {
        enable = false,
        disable = { "python", "css", "rust" }
    },
    autotag = {
        enable = true,
        filetypes = {
            'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact',
            'svelte', 'vue', 'tsx', 'jsx', 'rescript',
            'css', 'lua', 'xml', 'php', 'markdown', 'go'
        },
    },

    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}
