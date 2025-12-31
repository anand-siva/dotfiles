return {
  "folke/snacks.nvim",
  opts = {
    image = { enabled = true },
    picker = {
      previewers = {
        file = {
          ft_detect = true,
          max_size = 1024 * 1024 * 10, -- 10MB
        },
      },
      sources = {
        files = { preview = "preview" },
        explorer = { preview = "preview" },
      },
    },
  },
}
