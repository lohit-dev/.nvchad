require "nvchad.autocmds"

-- nvdash is a special buffer; global 'number' must be disabled per-window
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
  pattern = "nvdash",
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.cursorline = false
    vim.wo.signcolumn = "no"
    vim.wo.foldcolumn = "0"
  end,
})

-- treesitter indent (nvim-treesitter v2 no longer configures this via setup opts)
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "go",
    "rust",
    "javascript",
    "typescript",
    "tsx",
    "javascriptreact",
    "typescriptreact",
    "html",
    "css",
    "json",
    "yaml",
    "toml",
    "lua",
  },
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
