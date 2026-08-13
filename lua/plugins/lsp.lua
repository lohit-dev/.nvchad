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
      -- nvim-java/mason-registry alongside the default registry: adds the
      -- jdtls/java-test/java-debug-adapter/lombok packages (with fixes for
      -- version-pinning quirks in the upstream jars) that nvim-java
      -- (plugins/java.lua) installs and manages on its own -- none of
      -- those need to be listed in ensure_installed below, nvim-java pulls
      -- them in itself the first time a .java buffer opens.
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
      ensure_installed = {
        "gopls",
        "rust-analyzer",
        "pyright",
        "tsgo",
        "lua-language-server",
        "dockerfile-language-server",
        "json-lsp",
        "yaml-language-server",
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
      },
      -- Enables each installed server via `vim.lsp.enable()` the moment
      -- Mason confirms it's actually installed, rather than eagerly at
      -- startup -- lets freshly-added servers attach automatically once
      -- their (async, backgrounded) install finishes, instead of failing
      -- with "not installed, missing from PATH, or not executable" if you
      -- open a matching file before the install completes.
      --
      -- jdtls stays excluded even though it's no longer in either
      -- ensure_installed list above: nvim-java's own registry installs a
      -- package also named "jdtls", and automatic_enable would otherwise
      -- call plain `vim.lsp.enable("jdtls")` on it -- a second,
      -- differently-configured client racing the one nvim-java starts via
      -- `require("lspconfig").jdtls.setup()` (plugins/java.lua) for the
      -- same buffer.
      automatic_enable = { exclude = { "jdtls" } },
    },
  },
}
