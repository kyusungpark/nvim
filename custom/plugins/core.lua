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
      }
    }
  },
}
