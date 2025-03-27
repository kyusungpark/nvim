-- Custom init file to set Neovim options

local opt = vim.opt

-- Enable line numbers and relative line numbers
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers

opt.scrolloff = 8         -- Keep 8 lines above/below cursor when scrolling
opt.cursorline = true     -- Highlight current line

-- Clipboard
opt.clipboard = "unnamedplus" -- Use system clipboard
