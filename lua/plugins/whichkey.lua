return {
	{
		"folke/which-key.nvim",
		lazy = false,
		opts = function(_, opts)
			opts = opts or {}
			opts.plugins = vim.tbl_deep_extend("force", opts.plugins or {}, {
				marks = false,
			})
			-- Always show at the bottom -- no_overlap is what actually needs to
			-- be off here: which-key repositions/shrinks the popup whenever it
			-- would overlap the cursor's screen row, which silently overrides the
			-- fixed `row` above whenever the cursor is near the bottom of the
			-- screen (that's why the popup looked complete at the top of a file
			-- but got clipped to a handful of entries at the bottom -- it wasn't
			-- respecting the fixed row at all in that case).
			opts.win = vim.tbl_deep_extend("force", opts.win or {}, {
				row = vim.o.lines,
				no_overlap = false,
			})
			-- Group labels for every <leader> prefix
			opts.spec = {
				-- AI
				{ "<leader>a", group = "󰭹 AI (Copilot)" },
				{ "<leader>aa", desc = "Toggle chat" },
				{ "<leader>ae", desc = "Explain selection" },
				{ "<leader>am", desc = "Pick model" },

				-- Buffers
				{ "<leader>b", group = "󰓩 Buffers" },
				{ "<leader>br", desc = "Close right" },
				{ "<leader>bl", desc = "Close left" },
				{ "<leader>x", desc = "Close buffer" },

				-- Code / LSP
				{ "<leader>c", group = " Code & LSP" },
				{ "<leader>ca", desc = "Code action" },
				{ "<leader>cq", desc = "Quick-fix (apply first)" },
				{ "<leader>cd", desc = "Line diagnostics" },
				{ "<leader>ce", desc = "Next error" },
				{ "<leader>ch", desc = "Cheatsheet" },
				{ "<leader>cm", desc = "Git commits" },
				{ "<leader>ci", desc = "Toggle inlay hints" },
				{ "<leader>cc", desc = "Code snapshot -> clipboard", mode = "x" },
				{ "<leader>cs", desc = "Code snapshot -> file", mode = "x" },

				-- Diff
				{ "<leader>d", group = " Diff" },
				{ "<leader>dd", desc = "Open diffview" },
				{ "<leader>ds", desc = "Diagnostic loclist" },

				-- Explorer / Editor
				{ "<leader>e", desc = "󰙅 File explorer" },

				-- Find (Telescope)
				{ "<leader>f", group = " Find (Telescope)" },
				{ "<leader>ff", desc = "Find files" },
				{ "<leader>fw", desc = "Live grep" },
				{ "<leader>fb", desc = "Buffers" },
				{ "<leader>fh", desc = "Help tags" },
				{ "<leader>fo", desc = "Recent files" },
				{ "<leader>fz", desc = "Fuzzy (current buffer)" },

				-- Git (Telescope)
				{ "<leader>g", group = " Git" },
				{ "<leader>gt", desc = "Status" },

				-- Hunks (Gitsigns)
				{ "<leader>h", group = "󰊢 Hunks (Gitsigns)" },
				{ "<leader>hs", desc = "Stage hunk" },
				{ "<leader>hr", desc = "Reset hunk" },
				{ "<leader>hu", desc = "Undo stage hunk" },
				{ "<leader>hS", desc = "Stage buffer" },
				{ "<leader>hR", desc = "Reset buffer" },
				{ "<leader>hp", desc = "Preview hunk" },
				{ "<leader>hb", desc = "Blame line" },

				-- Marks
				{ "<leader>m", group = "󰃃 Marks" },
				{ "<leader>ma", desc = "Find marks" },

				-- Overseer (tasks)
				{ "<leader>o", group = " Tasks (Overseer)" },

				-- Toggle
				{ "<leader>n", desc = "󰿠 Toggle line numbers" },

				-- Rename / Relative numbers
				{ "<leader>r", group = " Rename / Numbers" },
				{ "<leader>rn", desc = "Rename symbol" },

				-- Signature / Search
				{ "<leader>s", group = "󰍉 Signature / Search" },
				{ "<leader>sh", desc = "Signature help" },

				-- Theme
				{ "<leader>t", group = "󰏘 Theme" },
				{ "<leader>th", desc = "Change theme" },

				-- Misc
				{ "<leader>u", desc = "󰅨 Toggle case of word" },

				-- Windows / WhichKey
				{ "<leader>w", group = "󱂬 Windows" },
				{ "<leader>w=", desc = "Equalize splits" },
				{ "<leader>wK", desc = "All keymaps" },
				{ "<leader>wk", desc = "WhichKey for keymap" },

				-- Close buffer
				{ "<leader>x", desc = "󰅙 Close buffer" },
			}
			return opts
		end,
		config = function(_, opts)
			dofile(vim.g.base46_cache .. "whichkey")
			require("which-key").setup(opts)
			pcall(vim.keymap.del, "n", "'")
		end,
	},
}
