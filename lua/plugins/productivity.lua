return {
  {
    "ahmedkhalf/project.nvim",
    lazy = false,
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("project_nvim").setup {
        detection_methods = { "lsp", "pattern" },
        patterns = {
          ".git",
          ".hg",
          ".svn",
          "Makefile",
          "justfile",
          "package.json",
          "package-lock.json",
          "pnpm-lock.yaml",
          "pnpm-workspace.yaml",
          "yarn.lock",
          "bun.lock",
          "bun.lockb",
          "tsconfig.json",
          "jsconfig.json",
          "deno.json",
          "deno.jsonc",
          "go.mod",
          "Cargo.toml",
          "pyproject.toml",
          "requirements.txt",
          "Pipfile",
          "poetry.lock",
          "setup.py",
          "composer.json",
          "Gemfile",
          "mix.exs",
          "rebar.config",
          "build.zig",
          "CMakeLists.txt",
        },
        silent_chdir = true,
      }

      require("telescope").load_extension "projects"
    end,
  },

  {
    "stevearc/dressing.nvim",
    opts = {},
  },

  {
    "axelvc/template-string.nvim",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      filetypes = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
      remove_template_string = true,
      restore_quotes = { normal = [[']], jsx = [["]] },
    },
  },
}
