-- Spring Boot isn't set up yet (per the jdtls comment in configs/lspconfig.lua),
-- but the run command itself doesn't depend on any of that -- it's just the
-- Maven/Gradle wrapper's boot-run goal. Wiring this now means it's just
-- there, correctly, whenever a Spring Boot project actually shows up,
-- instead of being another thing to remember to configure later.
--
-- Detection deliberately checks file *contents*, not just presence of
-- pom.xml/build.gradle -- those exist for any Maven/Gradle project, Spring
-- Boot or not, and this shouldn't show up as a run task for e.g. a plain
-- Gradle library.

local function find_project_root()
	local start = vim.fn.expand("%:p:h")
	local marker = vim.fs.find({ "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts" }, {
		upward = true,
		path = start,
	})[1]
	return marker and vim.fs.dirname(marker) or nil
end

local function file_contains(path, needle)
	local f = io.open(path, "r")
	if not f then
		return false
	end
	local content = f:read("*a")
	f:close()
	return content:find(needle, 1, true) ~= nil
end

local function is_spring_boot_project(root)
	local pom = root .. "/pom.xml"
	if vim.fn.filereadable(pom) == 1 and file_contains(pom, "spring-boot") then
		return true, "maven"
	end
	for _, name in ipairs({ "build.gradle", "build.gradle.kts" }) do
		local path = root .. "/" .. name
		if vim.fn.filereadable(path) == 1 and file_contains(path, "org.springframework.boot") then
			return true, "gradle"
		end
	end
	return false, nil
end

return {
	name = "Spring Boot: run",
	builder = function()
		local root = find_project_root()
		if not root then
			return { cmd = { "echo", "No Maven/Gradle project found" }, components = { "default" } }
		end

		local is_boot, build_tool = is_spring_boot_project(root)
		if not is_boot then
			return { cmd = { "echo", "Not a Spring Boot project (no spring-boot in pom.xml/build.gradle)" }, components = { "default" } }
		end

		if build_tool == "maven" then
			local mvnw = vim.fs.find("mvnw", { path = root })[1]
			return { cmd = { mvnw or "mvn", "-f", root, "spring-boot:run" }, components = { "default" } }
		end

		local gradlew = vim.fs.find("gradlew", { path = root })[1]
		return { cmd = { gradlew or "gradle", "-p", root, "bootRun" }, components = { "default" } }
	end,
	condition = {
		filetype = { "java" },
	},
}
