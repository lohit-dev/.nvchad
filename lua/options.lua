require "nvchad.options"

-- Dev tool bins missing from default shell PATH (mirrors conf.d/hyde/env.zsh)
local path_prepend = {}
for _, dir in ipairs {
  vim.fn.expand "~/go/bin",
  vim.fn.stdpath "data" .. "/mason/bin",
  vim.fn.expand "~/.cargo/bin",
  vim.fn.expand "~/.bun/bin",
} do
  if vim.fn.isdirectory(dir) == 1 then
    table.insert(path_prepend, dir)
  end
end
if #path_prepend > 0 then
  vim.env.PATH = table.concat(path_prepend, ":") .. ":" .. vim.env.PATH
end

local o = vim.o
o.cursorlineopt = "both"
vim.opt.updatetime = 250
vim.opt.laststatus = 3
