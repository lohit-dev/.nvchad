return {
	-- Switched from nvim-jdtls + spring-boot.nvim to nvim-java: it manages
	-- its own JDK, jdtls, java-test, java-debug-adapter, and lombok installs
	-- through its own Mason registry (registries below), and includes Spring
	-- Boot support (completion/validation for annotations and
	-- application.properties/yml) out of the box -- one plugin instead of
	-- three, with no ftplugin/java.lua of our own to maintain. The two
	-- approaches are also mutually exclusive: nvim-java replaces nvim-jdtls
	-- entirely rather than building on it.
	--
	-- One trade-off worth knowing: nvim-java pulls in mfussenegger/nvim-dap
	-- and nvim-java-dap as hard dependencies (there's no supported way to
	-- install it without them), so DAP support comes along whether it gets
	-- used or not. It's inert unless something actually calls into it though
	-- -- running/testing here still goes through overseer (<leader>or /
	-- overseer/template/user/*.lua), not nvim-java's own DAP-backed runner.
	--
	-- Loaded on `ft = "java"` like the rest of this config's language
	-- plugins (go.lua, rust.lua); its `config` function runs exactly once,
	-- the first time a .java buffer opens, and both nvim-java itself and
	-- jdtls need to be initialized in that same call, in this order --
	-- nvim-java's setup() has to run before lspconfig's jdtls.setup() so it
	-- can register its own jdtls command/bundles first.
	{
		"nvim-java/nvim-java",
		ft = "java",
		dependencies = {
			"nvim-java/lua-async-await",
			"nvim-java/nvim-java-refactor",
			"nvim-java/nvim-java-core",
			"nvim-java/nvim-java-test",
			"nvim-java/nvim-java-dap",
			"MunifTanjim/nui.nvim",
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("java").setup()
			require("lspconfig").jdtls.setup({
				capabilities = require("nvchad.configs.lspconfig").capabilities,
			})
		end,
	},
}
