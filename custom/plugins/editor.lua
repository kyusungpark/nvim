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

  -- Bufferline for tab management
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin buffer" },
      { "<leader>bc", "<Cmd>BufferLinePickClose<CR>", desc = "Close buffer picker" },
      { "<S-h>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
      { "<S-l>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          numbers = "none",
          close_command = "bdelete! %d",
          right_mouse_command = "bdelete! %d",
          left_mouse_command = "buffer %d",
          middle_mouse_command = nil,
          indicator = {
            icon = "▎",
            style = "icon",
          },
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          max_name_length = 30,
          max_prefix_length = 30,
          tab_size = 21,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(count, level)
            local icon = level:match("error") and " " or " "
            return " " .. icon .. count
          end,
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
              separator = true,
            }
          },
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin",
          enforce_regular_tabs = true,
          always_show_bufferline = true,
        },
      })
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
}
