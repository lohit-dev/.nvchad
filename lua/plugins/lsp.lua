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
    },
  },
}
