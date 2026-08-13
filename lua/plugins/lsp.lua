return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
    },
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "rust-analyzer",
        "pyright",
        "tsgo",
        "lua-language-server",
        "dockerfile-language-server",
        "json-lsp",
        "yaml-language-server",
        "jdtls",
        -- Not wired to anything yet (no nvim-dap / nvim-jdtls in this
        -- config) -- installed now so the jars are already sitting in
        -- Mason's registry once Spring Boot work starts and these get
        -- hooked up as jdtls bundles for debugging/test-running.
        "java-debug-adapter",
        "java-test",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "tsgo",
        "rust_analyzer",
        "pyright",
        "lua_ls",
        "dockerls",
        "jsonls",
        "yamlls",
        "jdtls",
      },
      -- Enables each installed server via `vim.lsp.enable()` the moment
      -- Mason confirms it's actually installed, rather than eagerly at
      -- startup -- lets freshly-added servers attach automatically once
      -- their (async, backgrounded) install finishes, instead of failing
      -- with "not installed, missing from PATH, or not executable" if you
      -- open a matching file before the install completes.
      --
      -- jdtls is excluded here specifically: automatic_enable calls plain
      -- `vim.lsp.enable("jdtls")` for *any* mason-installed server unless
      -- excluded, regardless of whether it's in ensure_installed above --
      -- that would start a second, differently-configured jdtls client
      -- racing the one nvim-jdtls starts from ftplugin/java.lua for the
      -- same buffer. jdtls still gets installed by Mason either way
      -- (ensure_installed only controls install, not enabling); this just
      -- stops mason-lspconfig from also trying to start it itself.
      automatic_enable = { exclude = { "jdtls" } },
    },
  },
  -- Bottom-right progress UI: shows "gopls: loading packages", "rust-analyzer:
  -- indexing", etc. while a server is doing work, so you can actually tell
  -- an LSP is alive and busy vs. just not attached at all.
  {
    "j-hui/fidget.nvim",
    enabled = false,
    event = "LspAttach",
    opts = {},
  },
}
