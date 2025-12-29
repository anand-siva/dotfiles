-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false })

vim.keymap.set("n", "<leader>cp", function()
  -- Track state ourselves (starts disabled)
  vim.g._copilot_enabled = vim.g._copilot_enabled or false

  if vim.g._copilot_enabled then
    vim.cmd("Copilot disable")
    vim.g._copilot_enabled = false
    vim.notify("Copilot: disabled")
  else
    vim.cmd("Copilot enable")
    vim.g._copilot_enabled = true
    vim.notify("Copilot: enabled")
  end
end, { desc = "Toggle Copilot" })
