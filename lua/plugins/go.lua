return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua", -- floating UI (GoTest floaterm, GoDoc float, etc.)
      "neovim/nvim-lspconfig",
    },
    ft = { "go", "gomod" },
    build = function()
      -- Same story as gopher's GoInstallDepsSync before it: the async
      -- version returns before `go install` actually finishes putting
      -- gomodifytags/gotests/impl/etc. in GOBIN, so a plain
      -- `:lua require("go.install").update_all_sync()` (the command the
      -- go.nvim README suggests for `build`) is used here specifically
      -- because it's the *_sync* variant -- it blocks until every binary is
      -- actually in place instead of racing nvim's exit.
      vim.cmd [[lua require("go.install").update_all_sync()]]
    end,
    opts = {
      -- go.nvim can drive gopls itself (lsp_cfg = true), but this repo
      -- already configures gopls by hand in configs/lspconfig.lua
      -- (gofumpt, staticcheck, inlay hints, etc.) and enables it through
      -- mason-lspconfig -- leaving lsp_cfg at its default `false` keeps
      -- go.nvim to its non-LSP tooling (tags, GoIfErr, GoImpl, test
      -- generation, dap-go, ...) instead of starting a second, differently
      -- configured gopls racing the existing one.
      lsp_cfg = false,
    },
    config = function(_, opts)
      require("go").setup(opts)

      -- Deliberately no BufWritePre goimports autocmd here, unlike the
      -- go.nvim README's suggested setup -- conform.nvim already runs
      -- goimports + gofmt on save for the `go` filetype
      -- (configs/conform.lua). Adding go.nvim's own format-on-save on top
      -- would just format every Go buffer twice.

      -- Same PATH fix gopher.nvim needed: `go install` (via
      -- `go.install.update_all_sync` above) puts gomodifytags/gotests/
      -- impl/etc. in `go env GOBIN` (or GOPATH/bin, default ~/go/bin). If
      -- nvim started from a shell/session where that dir isn't on PATH,
      -- the binaries exist but go.nvim can't find them.
      local go_bin = vim.env.GOBIN
        or (vim.env.GOPATH and vim.env.GOPATH ~= "" and vim.env.GOPATH .. "/bin")
        or vim.fn.expand "~/go/bin"
      if vim.fn.isdirectory(go_bin) == 1 and not vim.env.PATH:find(go_bin, 1, true) then
        vim.env.PATH = go_bin .. ":" .. vim.env.PATH
      end
    end,
  },
}
