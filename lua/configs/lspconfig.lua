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

local servers = { "html", "cssls", "gopls", "tsgo", "pyright", "lua_ls", "dockerls", "jsonls", "yamlls" }
vim.lsp.enable(servers)
