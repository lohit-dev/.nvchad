return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
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
		},
		cmd = {
			"CopilotChat",
			"CopilotChatOpen",
			"CopilotChatClose",
			"CopilotChatToggle",
			"CopilotChatStop",
			"CopilotChatReset",
			"CopilotChatSave",
			"CopilotChatLoad",
			"CopilotChatPrompts",
			"CopilotChatModels",
			"CopilotChatExplain",
		},
		build = "make tiktoken",
		opts = {
			-- GitHub's own model-router: picks from the currently-available
			-- model set per-request based on load/task rather than one fixed
			-- id, which is what was going stale and throwing "Model not found."
			-- <leader>am (mappings.lua) still opens the picker if you ever want
			-- to override this for a specific chat.
			model = "auto",
		},
	},
}
