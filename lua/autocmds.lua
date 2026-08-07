require "nvchad.autocmds"

-- Organize imports (remove unused, sort) before formatting on save, for
-- Go/TS/JS -- matches lvim's config.format organize_imports behavior.
-- Go already gets this from goimports (a conform formatter, see
-- configs/conform.lua) so this only needs to cover TS/JS/TSX/JSX, where
-- prettier (also conform) handles whitespace/reflow but never touches
-- import order -- that's a codeaction only the LSP (tsgo) can do.
local organize_imports_fts = {
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("organize-imports-on-save", { clear = true }),
  pattern = { "*.ts", "*.tsx", "*.js", "*.jsx" },
  callback = function(args)
    local buf = args.buf
    if not organize_imports_fts[vim.bo[buf].filetype] then
      return
    end
    local enc = (vim.lsp.get_clients({ bufnr = buf })[1] or {}).offset_encoding or "utf-16"
    local params = vim.lsp.util.make_range_params(0, enc)

    ---@diagnostic disable-next-line: inject-field
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(buf, "textDocument/codeAction", params, 1000)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local client_enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, client_enc)
        end
      end
    end
  end,
})
