return {
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

        -- Python
        "pyright",
        "black",
        "mypy",
        "ruff",

        -- HTML/CSS
        "html-lsp",
        "css-lsp",
        "tailwindcss",
        "emmet-ls",
      }
    }
  },
}
