---@type overseer.TemplateFileDefinition

local run_cmds = {
  javascript = function()
    return { "bun", vim.fn.expand "%:p" }
  end,
  javascriptreact = function()
    return { "bun", vim.fn.expand "%:p" }
  end,
  typescript = function()
    return { "bun", vim.fn.expand "%:p" }
  end,
  typescriptreact = function()
    return { "bun", vim.fn.expand "%:p" }
  end,
  go = function()
    return { "go", "run", vim.fn.expand "%:p" }
  end,
  rust = function()
    return { "cargo", "run" }
  end,
  lua = function()
    return { "nvim", "-l", vim.fn.expand "%:p" }
  end,
  python = function()
    return { "python3", vim.fn.expand "%:p" }
  end,
  swift = function()
    return { "swift", vim.fn.expand "%:p" }
  end,
  java = function()
    return { "java", vim.fn.expand "%:p" }
  end,
}

return {
  name = "Run current file",
  builder = function()
    return {
      cmd = run_cmds[vim.bo.filetype](),
      components = { "default" },
    }
  end,
  condition = {
    filetype = vim.tbl_keys(run_cmds),
  },
}
