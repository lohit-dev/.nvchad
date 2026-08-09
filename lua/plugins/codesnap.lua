return {
	{
		"mistricky/codesnap.nvim",
		-- `make` mounts a precompiled generator binary for the common targets
		-- (x86_64-linux-gnu, x86_64-darwin, aarch64-darwin) -- no Rust toolchain
		-- needed for those. If yours isn't in that list, swap this for
		-- `build = "make build_generator"` (needs Rust installed) to compile
		-- from source instead.
		build = "make",
		keys = {
			{ "<leader>cc", "<cmd>CodeSnap<cr>", mode = "x", desc = "Snapshot selection to clipboard" },
			{ "<leader>cs", "<cmd>CodeSnapSave<cr>", mode = "x", desc = "Snapshot selection to file" },
		},
		opts = {
			save_path = os.getenv("HOME") .. "/Pictures",
			has_breadcrumbs = false,
			bg_theme = "default",
			mac_window_bar = true,
			code_font_family = "JetBrainsMono Nerd Font",
			watermark = "",
		},
	},
}
