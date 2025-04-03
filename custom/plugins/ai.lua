return {
  -- GitHub Copilot
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Enable Copilot for all filetypes
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_no_tab_map = true  -- We'll manually map tab below

      -- TODO: Remove later Disable Copilot for Go files
      -- vim.g.copilot_filetypes = {
      --   ["go"] = false
      -- }

      -- Use Tab to accept suggestions
      vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<Tab>")', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Next()', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Previous()', { silent = true, expr = true })
    end,
  },

  -- Copilot Chat - For interactive chat and code edits
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    cmd = {
      "CopilotChat",
      "CopilotChatVisual",
      "CopilotChatInPlace",
      "CopilotChatExplain",
      "CopilotChatTests",
      "CopilotChatReview",
      "CopilotChatFix",
    },
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      model = "claude-3.7-sonnet", -- Model to use for chat
      show_help = true, -- Show help text for CopilotChatInPlace
      context = "selection", -- Default context to use (buffer, selection)
      temp_dir = "/tmp/copilot-chat", -- Directory for temporary files

      window = {
        width = 0.3
      }
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      -- Set up keymappings for CopilotChat commands
      local keymap = vim.keymap.set

      -- Use <leader>c as the prefix for CopilotChat commands
      keymap("n", "<leader>co", ":CopilotChat<CR>", { desc = "CopilotChat - Open chat" })
      keymap("v", "<leader>co", ":CopilotChatVisual<CR>", { desc = "CopilotChat - Visual selection" })
      keymap("n", "<leader>ci", ":CopilotChatInPlace<CR>", { desc = "CopilotChat - In-place edit" })
      keymap("v", "<leader>ci", ":CopilotChatInPlace<CR>", { desc = "CopilotChat - In-place edit (visual)" })
      keymap("n", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "CopilotChat - Explain code" })
      keymap("v", "<leader>ce", ":CopilotChatExplain<CR>", { desc = "CopilotChat - Explain selection" })
      keymap("n", "<leader>ct", ":CopilotChatTests<CR>", { desc = "CopilotChat - Generate tests" })
      keymap("v", "<leader>ct", ":CopilotChatTests<CR>", { desc = "CopilotChat - Generate tests for selection" })
      keymap("n", "<leader>cr", ":CopilotChatReview<CR>", { desc = "CopilotChat - Review code" })
      keymap("v", "<leader>cr", ":CopilotChatReview<CR>", { desc = "CopilotChat - Review selection" })
      keymap("n", "<leader>cf", ":CopilotChatFix<CR>", { desc = "CopilotChat - Fix code" })
      keymap("v", "<leader>cf", ":CopilotChatFix<CR>", { desc = "CopilotChat - Fix selection" })
    end,
  },
}
