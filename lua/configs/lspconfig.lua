require("nvchad.configs.lspconfig").defaults()

-- TypeScript 7+ (Go port, formerly previewed as tsgo) provides native LSP via `tsc`
local servers = { "html", "cssls", "tsc", "pyright" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
