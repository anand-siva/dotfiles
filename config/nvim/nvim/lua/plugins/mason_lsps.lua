-- lua/plugins/lsp.lua
return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "terraformls",
        "ruby_lsp",
      },
    },
  },
}
