local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		go = { "goimports", "gofmt" },
		rust = { "rustfmt" },
		-- java is deliberately NOT here. `lsp_fallback = true` below means
		-- format_on_save already reaches for whatever LSP formatter is
		-- attached when a filetype has no conform formatter of its own --
		-- for java that's jdtls's built-in formatter (enabled via
		-- settings.java.format in ftplugin/java.lua), so this Just Works
		-- without a separate external formatter (google-java-format etc.)
		-- being installed.
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
}

return options
