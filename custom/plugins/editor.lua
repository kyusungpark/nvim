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
}
