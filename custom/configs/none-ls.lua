local null_ls = require("null-ls")

local formatting = null_ls.builtins.formatting
local completion = null_ls.builtins.completion
local diagnostics = null_ls.builtins.diagnostics

local sources = {
  -- JavaScript/TypeScript formatting
  require("none-ls.diagnostics.eslint_d"),
  formatting.prettier,

  -- Go formatting
  formatting.gofmt,
  formatting.goimports,

  -- Python formatting
  formatting.black,
  diagnostics.mypy,
  diagnostics.ruff,

  -- Additional sources
  formatting.stylua,
  completion.spell,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Return configuration to be used with opts
return {
  debug = true,
  sources = sources,
  -- Format on save
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr
            -- filter = function(client)
            --   return client.name == "null-ls"
            -- end
          })
        end,
      })
    end
  end,
}
