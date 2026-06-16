return {
  {
    "mrcjkb/rustaceanvim",
    version = "^9",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          capabilities = require("nvchad.configs.lspconfig").capabilities,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = true,
              check = { command = "clippy" },
              procMacro = { enable = true },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
              },
              inlayHints = {
                enable = true,
                parameterHints = { enable = true },
                typeHints = { enable = true },
                chainingHints = { enable = true },
              },
            },
          },
        },
      }
    end,
  },
}
