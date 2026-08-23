return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    { "nvim-treesitter/nvim-treesitter" },
  },
  ft = { "go", "gomod" },
  opts = {
    lsp_cfg = true,
    -- Keep NvChad's global leader mappings; go.nvim's default LSP bundle
    -- installs a buffer-local <Space>e diagnostic mapping over <leader>e.
    lsp_keymaps = false,
  },
  config = function(_, opts)
    require("go").setup(opts)

    local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require("go.format").goimports()
      end,
      group = format_sync_grp,
    })
  end,
  build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
