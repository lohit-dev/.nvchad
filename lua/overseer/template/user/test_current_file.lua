-- Per-filetype "test current file" commands. Only JS/TS existed before;
-- added Go and Rust. No Lua entry -- there's no standard test-runner
-- convention for a lone Lua file in this config, so skipped rather than
-- guessing at one (e.g. busted/plenary) you didn't ask for.
local test_cmds = {
  javascript = function()
    return { "bun", "test", vim.fn.expand "%:p" }
  end,
  javascriptreact = function()
    return { "bun", "test", vim.fn.expand "%:p" }
  end,
  typescript = function()
    return { "bun", "test", vim.fn.expand "%:p" }
  end,
  typescriptreact = function()
    return { "bun", "test", vim.fn.expand "%:p" }
  end,
  go = function()
    return { "go", "test", "./..." }
  end,
  rust = function()
    return { "cargo", "test" }
  end,
}

return {
  name = "Test current file",
  builder = function()
    return {
      cmd = test_cmds[vim.bo.filetype](),
      components = { "default" },
    }
  end,
  condition = {
    filetype = vim.tbl_keys(test_cmds),
  },
}
