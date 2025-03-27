return {
  -- Auto Session
  {
    "rmagatti/auto-session",
    lazy = false,
    config = function()
      require("auto-session").setup({
        log_level = "error", -- "debug", "info", "error"
        auto_session_enable_last_session = false,
        auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
        auto_session_use_git_branch = true,
        auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      })

      -- Keymappings for session management
      vim.keymap.set("n", "<leader>ss", require("auto-session.session-lens").search_session,
        { noremap = true, silent = true, desc = "Search sessions" })
      vim.keymap.set("n", "<leader>sd", ":SessionDelete<CR>",
        { noremap = true, silent = true, desc = "Delete session" })
      vim.keymap.set("n", "<leader>sr", ":SessionRestore<CR>",
        { noremap = true, silent = true, desc = "Restore session" })
      vim.keymap.set("n", "<leader>sS", ":SessionSave<CR>",
        { noremap = true, silent = true, desc = "Save session" })
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim", -- For session-lens
    },
  },
}
