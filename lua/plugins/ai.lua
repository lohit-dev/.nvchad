return {
	{
		"zbirenbaum/copilot.lua",
		dependencies = {
			"copilotlsp-nvim/copilot-lsp",
		},
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
				},
				suggestion = {
					enabled = true,
					-- No ghost-text on every keystroke -- request one explicitly
					-- with <M-]> (mirrors VS Code Copilot's own next-suggestion
					-- shortcut) whenever you actually want it.
					auto_trigger = false,
					hide_during_completion = true,
					keymap = {
						accept = "<C-l>",
					},
				},
			})

			-- Start fully disabled. A fresh clone (no cache/state) would
			-- otherwise attach Copilot immediately on the first InsertEnter,
			-- which is exactly the "blocking" behaviour we don't want. Turn
			-- it on yourself with <leader>an (`:Copilot enable`) whenever you
			-- actually want suggestions for that session.
			vim.schedule(function()
				pcall(vim.cmd, "Copilot disable")
			end)

			vim.keymap.set("i", "<M-]>", function()
				require("copilot.suggestion").next()
			end, { desc = "Copilot: request suggestion" })
			vim.keymap.set("i", "<M-[>", function()
				require("copilot.suggestion").dismiss()
			end, { desc = "Copilot: dismiss suggestion" })

			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuOpen",
				callback = function()
					vim.b.copilot_suggestion_hidden = true
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "BlinkCmpMenuClose",
				callback = function()
					vim.b.copilot_suggestion_hidden = false
				end,
			})
		end,
	},
}
