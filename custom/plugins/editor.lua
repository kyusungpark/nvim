return {
  -- Multi-Select
  {
    "mg979/vim-visual-multi",
    branch = "master",
    event = "BufRead",
  },

  -- Auto rename and close HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
    opts = {
      autotag = {
        enable = true,
        filetypes = {
          "html", "xml", "javascript", "javascriptreact",
          "typescript", "typescriptreact", "tsx", "jsx",
          "markdown", "php", "vue", "svelte"
        },
      }
    }
  },

  -- Auto pairs for brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- Use treesitter to check for pairs
        ts_config = {
          lua = {"string", "source"},
          javascript = {"string", "template_string"},
        },
        fast_wrap = {
          map = "<M-e>", -- Alt+e to wrap text in pairs
          chars = { "{", "[", "(", '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment"
        },
      })

      -- Make it work with nvim-cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local ok, cmp = pcall(require, "cmp")
      if ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
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

  -- Todo comments highlighting and searching
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("todo-comments").setup({
        signs = true,      -- Show icons in the sign column
        keywords = {
          FIX = { icon = " ", color = "error" },
          TODO = { icon = " ", color = "info" },
          NOTE = { icon = " ", color = "hint" },
        },
        highlight = {
          before = "",     -- "fg" or "bg" or empty
          keyword = "wide", -- "fg", "bg", "wide" or empty
          after = "fg",    -- "fg" or "bg" or empty
          pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns
          comments_only = true, -- uses treesitter to match keywords in comments only
          max_line_len = 400, -- ignore lines longer than this
          exclude = {}, -- list of file types to exclude highlighting
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        },
      })
    end,
  },

  -- Rename variables globally with preview
  {
    "smjonas/inc-rename.nvim",
    event = "BufRead",
    config = function()
      require("inc_rename").setup({
        input_buffer_type = "dressing",
        preview_empty_name = false,  -- whether an empty new name should be previewed
        show_message = true,         -- show a message after executing
        cmd_name = "IncRename",      -- command name
        hl_group = "Substitute",     -- highlight group used for highlighting the identifier's new name
        ui_max_width = 0.5,          -- The maximum width of the UI window
        ui_min_width = 20,           -- The minimum width of the UI window
      })

      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename variable globally" })
    end,
  },

  -- Auto save files
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0", -- Use semver to ensure compatibility
    cmd = "ASToggle",    -- Enable lazy loading via command
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      -- Don't save special buffers
      condition = function(buf)
        -- Don't save if buffer is not modifiable
        if not vim.bo[buf].modifiable then
          return false
        end
        -- Don't save special buffers
        if vim.bo[buf].buftype ~= "" then
          return false
        end
        return true
      end,
      debounce_delay = 1000,
    },
    config = function(_, opts)
      -- Load the plugin
      local auto_save = require("auto-save")

      -- Setup with options
      auto_save.setup(opts)

      -- Create an autocmd group for auto-save notifications
      local group = vim.api.nvim_create_augroup('autosave', {})

      -- Show notification when a buffer is saved
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AutoSaveWritePost',
        group = group,
        callback = function(args)
          if args.data.saved_buffer ~= nil then
            local filename = vim.fn.fnamemodify(
              vim.api.nvim_buf_get_name(args.data.saved_buffer),
              ":t"
            )
            vim.notify(
              'AutoSave: saved ' .. filename .. ' at ' .. vim.fn.strftime('%H:%M:%S'),
              vim.log.levels.INFO
            )
          end
        end,
      })
    end,
  },

  -- Comment code with / key
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("Comment").setup({
        -- Use '/' for line comments
        mappings = {
          basic = false,
          extra = false,
        },
      })

      -- Map '/' to comment in normal mode
      vim.keymap.set('n', '/', function()
        require('Comment.api').toggle.linewise.current()
        return '<ESC>'
      end, { expr = true, desc = "Comment line" })

      -- Map '/' to comment in visual mode
      vim.keymap.set('x', '/', function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<ESC>', true, false, true), 'nx', false)
        require('Comment.api').toggle.linewise(vim.fn.visualmode())
      end, { desc = "Comment selection" })
    end,
  },

  -- Buffer line (tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- Change from VimEnter to an earlier event to ensure it loads immediately
    event = { "BufReadPost", "BufNewFile" },
    priority = 1000, -- Give it high priority to load early
    config = function()
      -- Ensure termguicolors is enabled globally, not just in the plugin scope
      vim.o.termguicolors = true

      -- Set to use mouse for buffer operations
      vim.o.mouse = "a"

      require("bufferline").setup({
        highlights = {
          buffer_selected = { bold = true },
          diagnostic_selected = { bold = true },
          info_selected = { bold = true },
          info_diagnostic_selected = { bold = true },
          warning_selected = { bold = true },
          warning_diagnostic_selected = { bold = true },
          error_selected = { bold = true },
          error_diagnostic_selected = { bold = true },
        },
        options = {
          mode = "buffers",
          numbers = "none", -- "none" | "ordinal" | "buffer_id"
          close_command = "bdelete! %d", -- command to use when closing a buffer
          right_mouse_command = "bdelete! %d", -- command to use on right mouse click
          left_mouse_command = "buffer %d", -- command to use on left mouse click
          middle_mouse_command = nil, -- command to use on middle mouse click
          indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon', -- 'icon' | 'underline' | 'none'
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          truncate_names = true, -- whether or not tab names should be truncated
          tab_size = 18,
          diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc"
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
          color_icons = true, -- whether or not to add the filetype icon highlights
          show_buffer_icons = true, -- disable filetype icons for buffers
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          separator_style = "thick", -- "slant" | "thick" | "thin" | { 'any', 'any' }
          enforce_regular_tabs = false,
          always_show_bufferline = true,
          hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
          },
        }
      })

      -- Keymappings for buffer navigation
      vim.keymap.set('n', '<S-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = "Next buffer" })
      vim.keymap.set('n', '<S-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = "Previous buffer" })
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha" },
          },
        },
        sections = {
          lualine_a = { { "mode", icon = "" } },
          lualine_b = {
            { "branch", icon = "" },
            {
              "diff",
              symbols = {
                added = " ",
                modified = " ",
                removed = " ",
              },
            },
          },
          lualine_c = {
            {
              "filename",
              path = 1, -- relative path
              symbols = {
                modified = "  ",
                readonly = "  ",
                unnamed = "[No Name]",
                newfile = "[New]",
              },
            },
            { "diagnostics" },
          },
          lualine_x = {
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              function()
                local msg = "No LSP"
                local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
                if #buf_clients == 0 then
                  return msg
                end
                local client_names = {}
                for _, client in ipairs(buf_clients) do
                  if client.name ~= "null-ls" then
                    table.insert(client_names, client.name)
                  end
                end
                return table.concat(client_names, ", ")
              end,
              icon = " LSP:",
              color = { gui = "bold" },
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            {
              function()
                return os.date("%R")
              end,
              icon = "",
            },
          },
        },
        extensions = { "neo-tree", "lazy" },
      })
    end,
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "VimEnter", -- Load on VimEnter instead of BufReadPre for earlier loading
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
      save_empty = false,
    },
    config = function(_, opts)
      require("persistence").setup(opts)

      -- Save session when exiting Neovim
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          -- Save the session when leaving Vim
          require("persistence").save()
        end,
      })

      -- Auto-restore session on startup with a delay to ensure all is loaded
      vim.defer_fn(function()
        -- Only autoload if Neovim started without file arguments
        if vim.fn.argc() == 0 then
          require("persistence").load()
        end
      end, 100) -- Small delay to ensure everything is initialized
    end,
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}
