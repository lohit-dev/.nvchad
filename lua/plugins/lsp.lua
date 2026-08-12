return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"b0o/SchemaStore.nvim",
		},
		config = function()
			require("configs.lspconfig")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"gopls",
				"rust-analyzer",
				"pyright",
				"tsgo",
				"lua-language-server",
				"dockerfile-language-server",
				"json-lsp",
				"yaml-language-server",
				"jdtls",
				-- Not wired to anything yet (no nvim-dap / nvim-jdtls in this
				-- config) -- installed now so the jars are already sitting in
				-- Mason's registry once Spring Boot work starts and these get
				-- hooked up as jdtls bundles for debugging/test-running.
				"java-debug-adapter",
				"java-test",
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "mason.nvim",
		opts = {
			ensure_installed = {
				"gopls",
				"tsgo",
				"rust_analyzer",
				"pyright",
				"lua_ls",
				"dockerls",
				"jsonls",
				"yamlls",
				"jdtls",
			},
			-- Default, made explicit: enables each server via `vim.lsp.enable()`
			-- the moment Mason confirms it's actually installed, rather than
			-- eagerly at startup. configs/lspconfig.lua's jdtls comment explains
			-- why this matters -- freshly-added servers (jdtls right now) get
			-- installed async in the background, and this is what makes them
			-- attach automatically once that finishes instead of failing with
			-- "not installed, missing from PATH, or not executable" if you open
			-- a matching file before the install completes.
			automatic_enable = true,
		},
	},
	-- Bottom-right progress UI: shows "gopls: loading packages", "rust-analyzer:
	-- indexing", etc. while a server is doing work, so you can actually tell
	-- an LSP is alive and busy vs. just not attached at all.
	{
		"j-hui/fidget.nvim",
		event = "LspAttach",
		opts = {},
	},
}
