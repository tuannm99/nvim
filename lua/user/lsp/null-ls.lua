local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local function file_exists(filename)
  local file = io.open(filename, "r")
  if file then
    file:close()
    return true
  end
  return false
end

null_ls.setup {
  debug = false,
  sources = {
    formatting.prettier.with {
      extra_filetypes = { "toml" },
      extra_args = { "--single-quote" },
    },
    diagnostics.eslint,
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua,
  },
}
