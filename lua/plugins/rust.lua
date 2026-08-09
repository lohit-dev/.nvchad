return {
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false,
		init = function()
			-- Matches lvim's config.rustaceanvim settings 1:1 (see lvim/lua/config/rustaceanvim.lua).
			-- default_settings (not `settings`) is deliberate: it merges with any
			-- VS Code / local rust-analyzer.json settings instead of replacing
			-- them outright -- same behavior lvim relies on.
			vim.g.rustaceanvim = {
				server = {
					capabilities = require("nvchad.configs.lspconfig").capabilities,
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								buildScripts = { enable = true },
							},
							check = { command = "clippy" },
							procMacro = { enable = true },
							inlayHints = {
								bindingModeHints = { enable = false },
								closureReturnTypeHints = { enable = "always" },
								lifetimeElisionHints = { enable = "skip_trivial" },
								typeHints = { enable = true },
							},
						},
					},
				},
			}
		end,
	},

	-- Cargo.toml had no completion/hover/actions at all -- rust-analyzer
	-- doesn't cover Cargo.toml itself, that's crates.nvim's job. Its `lsp`
	-- mode attaches a real (pseudo) LSP client to Cargo.toml buffers, so
	-- blink.cmp picks up version/feature completion automatically through
	-- its normal "lsp" source -- no separate completion source plugin needed.
	{
		"saecki/crates.nvim",
		event = { "BufRead Cargo.toml" },
		opts = {
			lsp = {
				enabled = true,
				actions = true, -- code actions: upgrade crate, upgrade all, etc.
				completion = true, -- version/feature completion via blink.cmp's lsp source
				hover = true, -- K on a crate/version shows crates.io info
			},
		},
	},
}
