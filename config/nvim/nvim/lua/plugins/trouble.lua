return {
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble diagnostics" },
      {
        "<leader>td",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Trouble buffer diagnostics",
      },
    },
  },
}
