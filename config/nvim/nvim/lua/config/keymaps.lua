-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { silent = false })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { silent = false })
vim.keymap.set("n", "<leader>r", function()
  pcall(function()
    require("snacks").bufdelete()
  end)
end, { desc = "Close buffer" })

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

-- Copy current file name / path to clipboard
vim.keymap.set("n", "<leader>cf", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Copy file name" })

vim.keymap.set("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>cg", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if not git_root or git_root == "" then
    vim.notify("Not inside a git repository", vim.log.levels.WARN)
    return
  end

  local file_path = vim.fn.expand("%:p")
  local relative_path = file_path:gsub("^" .. git_root .. "/", "")

  vim.fn.setreg("+", relative_path)
end, { desc = "Copy path relative to git root" })
