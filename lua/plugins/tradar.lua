return {
  {
    -- Đường dẫn checkout repo tradar trên máy -- sửa lại nếu không đúng vị trí.
    dir = "/home/minhtuan/dev/local/tradar/nvim",
    name = "tradar.nvim",
    -- lazy = false, không phải ft = "sql": .mongo/.redis/.esq chỉ thành
    -- filetype thật sau khi tradar tự chạy vim.filetype.add lúc load --
    -- ft trigger của lazy.nvim không bao giờ nhận ra chúng để load trước.
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("tradar").setup {}
    end,
  },
}
