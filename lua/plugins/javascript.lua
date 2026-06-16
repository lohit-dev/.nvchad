return {
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    ft = { "json", "package.json" },
    config = function()
      require("package-info").setup()
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = {},
  },
}
