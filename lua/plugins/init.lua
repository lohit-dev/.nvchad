return {
  { import = "plugins.lsp" },
  { import = "plugins.formatter" },
  { import = "plugins.treesitter" },
  { import = "plugins.go" },
  { import = "plugins.rust" },
  { import = "plugins.javascript" },
  { import = "plugins.harpoon" },
  { import = "plugins.ai" },
  { import = "plugins.leetcode" },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- test new blink
  { import = "nvchad.blink.lazyspec" },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      return opts
    end,
  },
  -- Override NvChad's nvim-tree: show gitignored and dotfiles (e.g. .env, .gitignore)
  {
    "nvim-tree/nvim-tree.lua",
    opts = function(_, opts)
      opts = opts or {}
      opts.git = vim.tbl_extend("force", opts.git or {}, { ignore = false })
      opts.filters = vim.tbl_extend("force", opts.filters or {}, { dotfiles = false })
      return opts
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      exclude = { filetypes = { "nvdash", "help", "lazy", "mason", "TelescopePrompt" } },
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },
  --git
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern" },
        patterns = { ".git", "Cargo.toml", "package.json", "go.mod" },
      }
    end,
  },
}
