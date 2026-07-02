local packages = {
  "typescript-language-server",
  "pyright",
  "gopls",
  "rust-analyzer",
  "lua-language-server",
  "stylua",
  -- "dotenv-linter",
}

return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      return opts or {}
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    cmd = { "MasonToolsInstall", "MasonToolsUpdate" },
    opts = {
      ensure_installed = packages,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 12,
    },
  },
}
