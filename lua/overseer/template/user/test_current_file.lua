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
  -- No single-file convention here (a lone .java file has no classpath to
  -- run JUnit against) -- unlike the others above, this walks up from the
  -- current file to find the enclosing Maven/Gradle project and runs that
  -- project's test task instead. Prefers the wrapper script (mvnw/gradlew)
  -- when present so the build uses the project-pinned tool version rather
  -- than whatever `mvn`/`gradle` happens to be on PATH.
  java = function()
    local start = vim.fn.expand "%:p:h"
    local maven = vim.fs.find({ "mvnw", "pom.xml" }, { upward = true, path = start })[1]
    local gradle = vim.fs.find({ "gradlew", "build.gradle", "build.gradle.kts" }, { upward = true, path = start })[1]

    if maven then
      local root = vim.fs.dirname(maven)
      local mvnw = vim.fs.find("mvnw", { path = root })[1]
      return { mvnw or "mvn", "-f", root, "test" }
    end
    if gradle then
      local root = vim.fs.dirname(gradle)
      local gradlew = vim.fs.find("gradlew", { path = root })[1]
      return { gradlew or "gradle", "-p", root, "test" }
    end

    vim.notify("No pom.xml/build.gradle found above " .. start, vim.log.levels.WARN, { title = "Overseer" })
    return { "echo", "No Maven/Gradle project found" }
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
