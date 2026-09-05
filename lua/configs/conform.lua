local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
  },

  format_on_save = function(bufnr)
    -- JDTLS owns Java formatting;
    if vim.bo[bufnr].filetype == "java" or vim.bo[bufnr].filetype == "go" then
      return
    end

    return {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_fallback = true,
    }
  end,
}

return options
