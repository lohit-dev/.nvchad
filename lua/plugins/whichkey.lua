return {
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = function(_, opts)
      opts = opts or {}
      opts.plugins = vim.tbl_deep_extend("force", opts.plugins or {}, {
        marks = false,
      })
      return opts
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
      pcall(vim.keymap.del, "n", "'")
    end,
  },
}
