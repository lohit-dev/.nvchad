-- Per-filetype "run current file" commands. Only JS/TS existed before; added
-- Go, Rust, and Lua. Rust runs via `cargo run` (the project's main bin) since
-- lone .rs files are almost always part of a Cargo project here. Lua runs via
-- `nvim -l`, Neovim's own headless Lua interpreter -- no external `lua`
-- binary required.
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
