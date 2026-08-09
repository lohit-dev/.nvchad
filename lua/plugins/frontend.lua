return {
	{
		"axelvc/template-string.nvim",
		ft = {
			"html",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
			"python",
			"cs",
		},
		opts = {
			filetypes = {
				"html",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"python",
				"cs",
			},
			jsx_brackets = true,
			remove_template_string = false,
			restore_quotes = {
				normal = [[']],
				jsx = [["]],
			},
		},
	},
}
