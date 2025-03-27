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
   },
}

-- NvimTree mappings
M.nvimtree = {
   n = {
      ["<leader>ee"] = { "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree" },
      ["<leader>ec"] = { "<cmd>NvimTreeCollapse<CR>", "Collapse NvimTree" },
   },
}

return M