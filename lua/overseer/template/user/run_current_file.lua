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
  -- Java 11+'s single-file source-launch mode: compiles in memory and runs
  -- straight off the .java file, no javac/classpath/project setup needed.
  -- Fine for a standalone file; once you're inside an actual Maven/Gradle
  -- project (Spring Boot included) reach for the "Spring Boot: run" task
  -- or `<leader>oc` (OverseerShell) with `mvn spring-boot:run` / `./gradlew
  -- bootRun` instead -- this won't see your project's classpath/dependencies.
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
