-- nvim-jdtls setup. See plugins/java.lua for the plugin spec (nvim-jdtls +
-- spring-boot.nvim) and configs/lspconfig.lua for why the plain
-- nvim-lspconfig `jdtls` default that used to live there got dropped in
-- favor of this -- nvim-lspconfig's default is "good enough to attach",
-- nvim-jdtls is the actual Java tooling on top of that: organize imports,
-- extract variable/constant/method, generate constructor/toString/
-- hashCode+equals, plus (via spring-boot.nvim below) Spring Boot completion
-- and diagnostics for annotations and application.properties/yml.
--
-- No nvim-dap wiring here on purpose (no debugging, per what was asked for).
-- java-debug-adapter/java-test stay installed via Mason (ensure_installed in
-- plugins/lsp.lua) for later, but aren't loaded as jdtls bundles -- running
-- and testing go through overseer instead: <leader>or opens the task picker
-- with "Run current file" / "Test current file" / "Spring Boot: run"
-- (overseer/template/user/*.lua), which already existed before this and
-- needed no changes.
--
-- This file runs once per Java buffer (ftplugin semantics: `:help
-- ftplugin`). jdtls.start_or_attach() is idempotent per root_dir -- opening
-- a second file in the same project reattaches to the already-running
-- server instead of spawning a duplicate.

local ok, jdtls = pcall(require, "jdtls")
if not ok then
	return
end

-- Same root markers used everywhere else Java-related in this config (see
-- overseer/template/user/spring_boot_run.lua and test_current_file.lua) --
-- mvnw/gradlew cover Maven/Gradle wrapper projects (including multi-module
-- Gradle, the common Spring Boot layout), .git is the fallback for a lone
-- file with no build tool yet. If NONE of those exist either (a genuinely
-- standalone .java file with no git init, the "open a random file" case),
-- fall back to the file's own directory rather than refusing to start --
-- jdtls is still useful without a project (diagnostics, completion,
-- navigation), it just won't see any dependencies beyond the JDK itself.
local root_dir = vim.fs.root(0, { "mvnw", "gradlew", "pom.xml", "build.gradle", "build.gradle.kts", ".git" })
	or vim.fs.dirname(vim.api.nvim_buf_get_name(0))
	or vim.fn.getcwd()

-- Per-project workspace, matching the isolation the old nvim-lspconfig
-- default gave for free (see removed comment in configs/lspconfig.lua) --
-- without this, switching between projects corrupts a shared jdtls index
-- instead of keeping each project's separately.
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

-- Mason's jdtls install ships a wrapper script (mason/bin/jdtls, already on
-- $PATH -- mason.nvim prepends its bin dir automatically) that resolves the
-- right java binary, classpath, and equinox launcher jar version for you.
-- Hand-building that `java -jar ...` command instead would mean re-pinning
-- the launcher jar's exact filename by hand after every jdtls update. If
-- you'd rather pin to the Homebrew jdtls you just installed instead of
-- Mason's, swap the string below for "/opt/homebrew/bin/jdtls" (Apple
-- Silicon) -- both are the same upstream wrapper-script convention, so
-- either works the same way from here on.
local cmd = { "jdtls", "-data", workspace_dir }

-- Wires spring-boot.nvim's jdtls extension jars in as bundles so the
-- Spring Boot language server (sts4) rides along on top of jdtls -- gives
-- you completion/validation for @Autowired, @Bean, application.yml/
-- .properties keys, etc. Safe no-op (empty bundles) if spring-boot.nvim
-- hasn't loaded yet for some reason.
local bundles = {}
local spring_ok, spring_boot = pcall(require, "spring_boot")
if spring_ok then
	vim.list_extend(bundles, spring_boot.java_extensions())
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
	cmd = cmd,
	root_dir = root_dir,
	capabilities = require("nvchad.configs.lspconfig").capabilities,
	settings = {
		java = {
			-- Matches gopls's gofumpt-equivalent stance elsewhere in this
			-- config (configs/lspconfig.lua) -- format on top of jdtls's
			-- own formatter rather than reaching for a separate tool.
			format = { enabled = true },
			signatureHelp = { enabled = true },
			completion = {
				favoriteStaticMembers = {
					"org.junit.jupiter.api.Assertions.*",
					"org.mockito.Mockito.*",
					"org.mockito.ArgumentMatchers.*",
				},
			},
			-- Off by default in jdtls: without this, editing any file in a
			-- multi-module Gradle project (the common Spring Boot layout --
			-- an api/ module alongside a common/ module under one
			-- settings.gradle) only gets you diagnostics for that one
			-- module instead of the whole build.
			import = { gradle = { enabled = true }, maven = { enabled = true } },
		},
	},
	init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	},
	-- Adds the jdtls-specific keymaps (organize imports, extract
	-- variable/constant/method, generate constructor/toString/
	-- hashCode+equals) under <leader>j once jdtls actually attaches --
	-- see whichkey.lua for the group label and mappings.lua's LspAttach
	-- autocmd for where the shared (gopls/tsgo/rust-analyzer/...) LSP
	-- keymaps get set.
	on_attach = function(_, bufnr)
		local map = function(lhs, fn, desc)
			vim.keymap.set("n", lhs, fn, { buffer = bufnr, desc = desc })
		end
		map("<leader>jo", jdtls.organize_imports, "Organize imports")
		map("<leader>jv", jdtls.extract_variable, "Extract variable")
		map("<leader>jc", jdtls.extract_constant, "Extract constant")
		map("<leader>jm", jdtls.extract_method, "Extract method")

		-- Same overseer.run_task + "open vsplit" pattern <leader>or uses in
		-- plugins/overseer.lua, just pre-picking the template by name
		-- instead of prompting -- these three templates already exist
		-- (overseer/template/user/*.lua) and needed no changes for this.
		local function run_named(name)
			require("overseer").run_task({ name = name }, function(task, err)
				if err then
					vim.notify(err, vim.log.levels.ERROR)
					return
				end
				if task then
					require("overseer").run_action(task, "open vsplit")
				end
			end)
		end
		map("<leader>jt", function()
			run_named("Test current file")
		end, "Test current file")
		map("<leader>jr", function()
			run_named("Run current file")
		end, "Run current file")
		map("<leader>jb", function()
			run_named("Spring Boot: run")
		end, "Spring Boot: run")
	end,
}

jdtls.start_or_attach(config)
