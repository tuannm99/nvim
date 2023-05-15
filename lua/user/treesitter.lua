local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = { "vue", "html", "lua", "markdown", "markdown_inline", "bash", "python", "typescript", "javascript", "tsx",  "go", "glimmer", "pug", "prisma", "rust" },
  -- ensure_installed = "all", -- one of "all" or a list of languages
  ignore_install = { "" }, -- List of parsers to ignore installing
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { }, -- list of language that will be disabled
  },
  indent = { enable = true, disable = { "python", "css" } },
  autotag = {
    enable = true,
    filetypes = {
      'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
      'css', 'lua', 'xml', 'php', 'markdown', 'go'
    },
  },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
}

