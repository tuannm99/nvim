return {
  dir = "/home/minhtuan/dev/local/judge-loop/plugins/nvim-judge-loop",
  lazy = true,
  config = function()
    require("judge-loop").setup({
      agent_url = "http://127.0.0.1:7070",
      auto_notify = true,
    })
  end,
}
