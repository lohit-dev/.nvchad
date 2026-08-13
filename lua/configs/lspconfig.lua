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
-- tsgo has no equivalent of gopls's `usePlaceholders` (buffer-inserted,
-- tab-through-able parameter snippets on completion) -- that's a client-side
-- VS Code feature historically, reimplemented server-side only by
-- typescript-language-server's `completions.completeFunctionCalls`, not by
-- tsgo. Closest available substitute that still works with tsgo: widen the
-- parameter-name inlay hints from the default "literals only" to every
-- call, so param names are visible inline while typing without needing to
-- invoke signature help at all. See also chadrc.lua (auto signature-help
-- disabled) and mappings.lua LspAttach (inlay hints enabled client-side).
vim.lsp.config("tsgo", {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
      },
    },
  },
})

-- Java is NOT handled here. Using nvim-java (plugins/java.lua) instead of a
-- manual jdtls setup -- it manages its own JDK/jdtls/java-test/
-- java-debug-adapter/lombok installs through its own Mason registry and
-- covers Spring Boot support out of the box, needing far less hand-rolled
-- config than wiring nvim-jdtls + spring-boot.nvim + Mason ourselves. It
-- calls `require("lspconfig").jdtls.setup({})` internally, which is why
-- jdtls stays out of both the plain `servers` list below and
-- mason-lspconfig's `automatic_enable` (plugins/lsp.lua) -- either one
-- calling `vim.lsp.enable("jdtls")` on top would start a second,
-- differently-configured client racing nvim-java's.
local servers = { "html", "cssls", "gopls", "tsgo", "pyright", "lua_ls", "dockerls", "jsonls", "yamlls" }
vim.lsp.enable(servers)
