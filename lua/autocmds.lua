require "nvchad.autocmds"

-- nvdash is a special buffer; global 'number' must be disabled per-window
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType", "BufRead", "BufNew" }, {
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if ft == "nvdash" or bufname:find "nvdash" then
      vim.notify(
        string.format("event=%s ft=%s bufname=%s number=%s", ev.event, ft, bufname, tostring(vim.wo.number)),
        vim.log.levels.INFO
      )
    end
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
