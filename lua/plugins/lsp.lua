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
			},
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
