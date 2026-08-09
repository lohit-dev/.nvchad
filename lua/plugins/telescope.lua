return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			"ahmedkhalf/project.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- Native (C) fuzzy sorter -- noticeably faster than telescope's
			-- default Lua sorter once a repo/grep result set gets big. `build =
			-- "make"` compiles it on install; needs `make` + a C compiler
			-- available, which you already have for Go/Rust toolchains anyway.
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		opts = function()
			local opts = require("nvchad.configs.telescope")
			opts.extensions = vim.tbl_deep_extend("force", opts.extensions or {}, {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			})
			return opts
		end,
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("projects")
			require("telescope").load_extension("fzf")
		end,
	},
}
