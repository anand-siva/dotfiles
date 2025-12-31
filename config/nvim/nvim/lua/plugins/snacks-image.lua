return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    opts = opts or {}
    opts.image = vim.tbl_deep_extend("force", opts.image or {}, {
      enabled = true,
      doc = { enabled = true }, -- markdown / docs
      formats = { "png", "jpg", "jpeg", "gif", "webp" },
    })
    return opts
  end,
}
