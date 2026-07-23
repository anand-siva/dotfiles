-- lua/plugins/lsp.lua
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "bashls",
        "jsonls",
        "ts_ls",
        "eslint",
        "yamlls",
        "terraformls",
        "ruby_lsp",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettier",
      },
    },
  },
}
