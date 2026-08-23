return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          capabilities = require("nvchad.configs.lspconfig").capabilities,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                buildScripts = { enable = true },
              },
              check = { command = "clippy" },
              procMacro = { enable = true },
              inlayHints = {
                bindingModeHints = { enable = false },
                closureReturnTypeHints = { enable = "always" },
                lifetimeElisionHints = { enable = "skip_trivial" },
                typeHints = { enable = true },
              },
            },
          },
        },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        actions = true, -- code actions: upgrade crate, upgrade all, etc.
        completion = true, -- version/feature completion via blink.cmp's lsp source
        hover = true, -- K on a crate/version shows crates.io info
      },
    },
  },
}
