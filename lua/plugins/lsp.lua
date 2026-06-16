return {
  {
    "neovim/nvim-lspconfig",
    -- Match NvChad load timing; overrides its default config via lazy merge
    event = "User FilePost",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvimtools/none-ls.nvim",
  },
}
