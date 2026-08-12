require("nvchad.configs.lspconfig").defaults()

local ok, schemastore = pcall(require, "schemastore")

if ok then
	vim.lsp.config("jsonls", {
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
				validate = { enable = true },
			},
		},
	})

	vim.lsp.config("yamlls", {
		settings = {
			yaml = {
				schemaStore = {
					enable = false,
					url = "",
				},
				schemas = schemastore.yaml.schemas(),
			},
		},
	})
end

-- Matches lvim's lsp/gopls.lua settings 1:1.
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			gofumpt = true,
			staticcheck = true,
			usePlaceholders = true,
			completeUnimported = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

-- nvim-lspconfig's tsgo default only covers javascript/javascriptreact/
-- typescript/typescriptreact -- lvim's lsp/tsc.lua also attaches to the
-- dotted jsx/tsx filetype variants some detectors emit, so add those here
-- too rather than replacing the (better than lvim's) default root_dir logic.
-- tsgo has no equivalent of gopls's `usePlaceholders` (buffer-inserted,
-- tab-through-able parameter snippets on completion) -- that's a client-side
-- VS Code feature historically, reimplemented server-side only by
-- typescript-language-server's `completions.completeFunctionCalls`, not by
-- tsgo. Closest available substitute that still works with tsgo: widen the
-- parameter-name inlay hints from the default "literals only" to every
-- call, so param names are visible inline while typing without needing to
-- invoke signature help at all. See also chadrc.lua (auto signature-help
-- disabled) and mappings.lua LspAttach (inlay hints enabled client-side).
vim.lsp.config("tsgo", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	settings = {
		typescript = {
			inlayHints = {
				parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
			},
		},
	},
})

-- Deliberately NOT using nvim-java here -- that's a much heavier layer
-- (bundles its own JDK management, DAP, test runner, etc.) than a single-
-- module setup needs. nvim-lspconfig ships a solid built-in jdtls default
-- (see its lsp/jdtls.lua) that already does the two things that matter most:
--   - per-project isolation: `-data <cache>/jdtls/workspace/<project-dir-name>`,
--     so switching between projects doesn't corrupt a shared jdtls workspace
--   - sane root detection: mvnw/gradlew/settings.gradle(.kts)/pom.xml/
--     build.gradle(.kts)/.git, covering both single- and multi-module
--     projects -- multi-module Gradle (the common Spring Boot layout, e.g. an
--     api/ module alongside a common/ module under one settings.gradle) is
--     already handled by that root_markers list, nothing extra needed here.
-- `vim.lsp.enable("jdtls")` alone is enough to pick that default up; just
-- adding the Lombok hook on top since Spring Boot code leans on it heavily.
--
-- Lombok (getters/setters/builders via annotations -- close to unavoidable
-- in Spring Boot code) needs jdtls started with a -javaagent pointing at the
-- lombok jar, which nvim-lspconfig's default cmd already forwards through
-- the JDTLS_JVM_ARGS env var. Uncomment once you've downloaded lombok.jar
-- (https://projectlombok.org/download) to enable it:
--   vim.env.JDTLS_JVM_ARGS = "-javaagent:" .. vim.fn.expand("~/.local/share/java/lombok.jar")
--
-- If/when debugging or a proper test runner is needed, that's what the
-- java-debug-adapter/java-test Mason packages (mason.nvim's ensure_installed
-- in lsp.lua) are pre-installed for -- they plug in as jdtls bundles via
-- mfussenegger/nvim-jdtls (https://github.com/mfussenegger/nvim-jdtls#java-debug-installation),
-- which is the point at which this would graduate from the plain
-- nvim-lspconfig default to that plugin's ftplugin-based start_or_attach.

-- jdtls is deliberately left OUT of the static `vim.lsp.enable(servers)`
-- list below. Every other server there was already sitting on disk from
-- previous Mason installs, so enabling them at startup was instant and
-- fine -- jdtls is brand new, and Mason installs it in the background
-- (async, takes a bit: it's a real JDK-backed language server, not a small
-- binary). Statically enabling it here means the FileType autocmd fires
-- the moment you open a .java file, tries to spawn `jdtls`, and fails with
-- "not installed, missing from PATH, or not executable" if that happens
-- before Mason's install finishes -- which it will, on a fresh install.
--
-- mason-lspconfig's `automatic_enable` (on by default, see plugins/lsp.lua)
-- is built exactly for this: it listens for Mason's package-install-success
-- event and calls `vim.lsp.enable("jdtls")` itself the moment the binary
-- actually exists -- and vim.lsp.enable() re-fires the FileType autocmd for
-- already-open buffers when called, so a .java file opened *before* the
-- install finished still attaches correctly right after, with no restart or
-- manual `:LspStart` needed. Once jdtls has been installed once, this is a
-- non-issue either way -- automatic_enable finds it already on disk at
-- every subsequent startup and enables it immediately, same as the others.
local servers = { "html", "cssls", "gopls", "tsgo", "pyright", "lua_ls", "dockerls", "jsonls", "yamlls" }
vim.lsp.enable(servers)
