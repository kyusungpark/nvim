local M = {}

M.escape_insert = {
   i = {
      ["jk"] = { "<ESC>", "Exit insert mode" },
   },
}

-- Window split mappings
M.window = {
   n = {
      ["<leader>sv"] = { "<cmd>vsplit<CR>", "Vertical split" },
      ["<leader>sh"] = { "<cmd>split<CR>", "Horizontal split" },
      ["<leader>sf"] = { "<C-w>w", "Focus next buffer/window" },
   },
}

-- NvimTree mappings
M.nvimtree = {
   n = {
      ["<leader>ee"] = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree" },
      ["<leader>ec"] = { "<cmd>NvimTreeCollapse<CR>", "Collapse NvimTree" },
      ["<leader>ef"] = { "<cmd>NvimTreeFocus<CR>", "Focus NvimTree" },
   },
}

return M