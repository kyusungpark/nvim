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

return M