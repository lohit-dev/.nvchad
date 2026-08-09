return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			"ahmedkhalf/project.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = function()
			return require("nvchad.configs.telescope")
		end,
		config = function(_, opts)
			require("telescope").setup(opts)
			require("telescope").load_extension("projects")
		end,
	},
}
