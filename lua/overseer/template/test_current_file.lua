---@type overseer.TemplateFileDefinition

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
  python = function()
    return { "python3", "-m", "pytest", vim.fn.expand "%:p" }
  end,
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
      components = {
        { "open_output", on_start = "always", direction = "vertical", focus = true },
        "default",
      },
    }
  end,
  condition = {
    filetype = vim.tbl_keys(test_cmds),
  },
}
