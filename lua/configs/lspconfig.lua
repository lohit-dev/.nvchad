require("nvchad.configs.lspconfig").defaults()

local ok, schemastore = pcall(require, "schemastore")

if ok then
  vim.lsp.config("jsonls", {
    settings = {
      json = {
        schemas = schemastore.json.schemas(),
        validate = { enable = true },
      },
    },
  })

  vim.lsp.config("yamlls", {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
          url = "",
        },
        schemas = schemastore.yaml.schemas(),
      },
    },
  })
end

-- Matches lvim's lsp/gopls.lua settings 1:1.
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      completeUnimported = true,
      analyses = {
        unusedparams = true,
        shadow = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

-- nvim-lspconfig's tsgo default only covers javascript/javascriptreact/
-- typescript/typescriptreact -- lvim's lsp/tsc.lua also attaches to the
-- dotted jsx/tsx filetype variants some detectors emit, so add those here
-- too rather than replacing the (better than lvim's) default root_dir logic.
vim.lsp.config("tsgo", {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
})

local servers = { "html", "cssls", "gopls", "tsgo", "pyright", "lua_ls", "dockerls", "jsonls", "yamlls" }
vim.lsp.enable(servers)
