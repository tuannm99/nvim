local null_ls_status_ok, fidget = pcall(require, "fidget")
if not null_ls_status_ok then
  return
end

fidget.setup {}
