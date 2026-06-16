local parsers = {
  "html",
  "css",
  "javascript",
  "typescript",
  "tsx",
  "rust",
  "go",
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "json",
  "yaml",
  "toml",
  "markdown",
  "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- nvim-treesitter v2 (main) does not support lazy-loading
    lazy = false,
    build = ":TSUpdate",
    dependencies = { "windwp/nvim-ts-autotag" },
    opts = {
      -- Used by NvChad's :TSInstallAll command
      ensure_installed = parsers,
    },
    config = function(_, opts)
      require("nvim-treesitter").setup {}

      local to_install = opts.ensure_installed or parsers
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install):wait(300000)
      end

      require("nvim-ts-autotag").setup {
        opts = {
          enable_close = true,
          enable_rename = true,
        },
      }
    end,
  },
}
