return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    init = function()
      -- Matches lvim's config.rustaceanvim settings 1:1 (see lvim/lua/config/rustaceanvim.lua).
      -- default_settings (not `settings`) is deliberate: it merges with any
      -- VS Code / local rust-analyzer.json settings instead of replacing
      -- them outright -- same behavior lvim relies on.
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
}
