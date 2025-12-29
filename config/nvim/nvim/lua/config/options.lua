-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

local opt = vim.opt

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

-- Editor behavior
opt.smartindent = true
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.termguicolors = true
