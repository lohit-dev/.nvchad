require("nvchad.configs.lspconfig").defaults()

-- Keep NvChad's diagnostic signs, with persisted control over inline messages.
require("diagnostic_virtual_text").apply()

-- TypeScript 7+ (Go port, formerly previewed as tsgo) provides native LSP via `tsc`
vim.lsp.config("yamlls", {
  filetypes = { "yaml", "yaml.gitlab", "yaml.helm-values" },
  settings = {
    yaml = {
      format = { enable = true },
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
    },
  },
})

local servers = {
  "html",
  "cssls",
  "tsc",
  "pyright",
  "sourcekit",
  "taplo",
  "dockerls",
  "docker_compose_language_service",
  "yamlls",
}
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
