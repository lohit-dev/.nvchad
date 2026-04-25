require("nvchad.configs.lspconfig").defaults()

local capabilities = require("nvchad.configs.lspconfig").capabilities

-- Enable inlay hints when client supports them (LspAttach replaces on_attach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-inlay-hints", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      check = {
        command = "clippy", -- use clippy instead of plain check
      },
      procMacro = { enable = true },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true, -- needed for some proc macros / build.rs
      },
      inlayHints = {
        enable = true,
        parameterHints = { enable = true },
        typeHints = { enable = true },
        chainingHints = { enable = true },
      },
    },
  },
})

-- Go (gopls)
vim.lsp.config("gopls", {
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      completeUnimported = true, -- suggests unimported pkgs like chi
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
        shadow = true,
        unusedvariable = true,
      },
      staticcheck = true,
      gofumpt = true, -- stricter gofmt (optional but nice)
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

-- Lua (lua_ls)
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  cmd = { "/opt/homebrew/bin/lua-language-server" },
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

-- Enable all LSP servers
vim.lsp.enable({ "html", "cssls", "gopls", "eslint", "lua_ls" })
