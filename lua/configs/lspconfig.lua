if vim.g.custom_lspconfig_loaded then
  return
end
vim.g.custom_lspconfig_loaded = true

require("nvchad.configs.lspconfig").defaults()

local capabilities = require("nvchad.configs.lspconfig").capabilities

local function lsp_cmd(name)
  local path = vim.fn.exepath(name)
  if path == "" then
    vim.notify(name .. " not found on PATH", vim.log.levels.WARN)
    return { name }
  end
  return { path }
end

-- Enable inlay hints for any LSP client that supports them
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-inlay-hints", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

-- Rust is handled by rustaceanvim (see lua/plugins/rust.lua), not vim.lsp.enable.

-- Go (gopls)
vim.lsp.config("gopls", {
  capabilities = capabilities,
  cmd = lsp_cmd "gopls",
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        unusedvariable = true,
      },
      staticcheck = true,
      gofumpt = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- ESLint
vim.lsp.config("eslint", {
  capabilities = capabilities,
  settings = { format = { enable = true } },
})

-- JavaScript / TypeScript
vim.lsp.config("ts_ls", {
  capabilities = capabilities,
  cmd = vim.list_extend(lsp_cmd "typescript-language-server", { "--stdio" }),
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_markers = {
    "tsconfig.json",
    "jsconfig.json",
    "package.json",
    ".git",
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "literal",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "literal",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- Lua (lua_ls) — overrides NvChad defaults with richer workspace indexing
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  cmd = lsp_cmd "lua-language-server",
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
      hint = { enable = true, semicolon = "Disable" },
      codeLens = { enable = true },
    },
  },
})

vim.lsp.enable { "html", "cssls", "gopls", "eslint", "ts_ls", "lua_ls" }
