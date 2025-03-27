local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- Javascript
        "typescript-language-server",
        "eslint-lsp",
        "eslint_d",
        "prettier",

        -- GO
        "gopls",
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end
  },

  {
    "nvimtools/none-ls.nvim",
    event = "VeryLazy",
    opts = function()
      return require "custom.configs.none-ls"
    end,
    dependencies = {
      "nvimtools/none-ls-extras.nvim",
      "nvim-lua/plenary.nvim",
    },
  },

  -- Highlights selected word
  {
    "RRethy/vim-illuminate",
    event = "BufRead",
    config = function()
      require('illuminate').configure({
        providers = { 'lsp', 'treesitter', 'regex' },
        delay = 200, -- Delay before highlighting
      })
    end,
  },

  -- GitHub Copilot
  {
    "github/copilot.vim",
    branch = "canary",
    lazy = false,
    dependencies = { "github/copilot.vim" },
    config = function()
      -- Enable Copilot for all filetypes
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""

      -- Set up keymappings for accepting suggestions
      vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Next()', { silent = true, expr = true })
      vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Previous()', { silent = true, expr = true })
    end,
  },

  -- Copilot Chat - For interactive chat and code edits
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false, -- Set to false to ensure it loads at startup
    branch = "canary", -- Specify branch at the plugin level
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
  },

  -- Multi-Select
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "BufRead",
  },

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

return plugins
