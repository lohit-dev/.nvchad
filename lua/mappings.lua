require("nvchad.mappings")

local map = vim.keymap.set

-- Inlay hints on/off is a global preference, not a per-buffer one -- persist
-- it to a tiny state file so <leader>ci actually sticks across restarts
-- instead of resetting to "on" every time nvim opens.
local inlay_hints_state_file = vim.fn.stdpath("state") .. "/inlay_hints_enabled"

local function inlay_hints_default()
	local f = io.open(inlay_hints_state_file, "r")
	if not f then
		return true -- on by default until toggled at least once
	end
	local content = f:read("*a")
	f:close()
	return vim.trim(content or "") ~= "0"
end

local function inlay_hints_save(enabled)
	local f = io.open(inlay_hints_state_file, "w")
	if f then
		f:write(enabled and "1" or "0")
		f:close()
	end
end

-- Terminal: not used -- tmux covers "new terminal" and overseer.nvim covers
-- running/watching commands, so drop NvChad's built-in terminal keymaps
-- entirely rather than leave dead/confusing bindings around.
--   <leader>h / <leader>v   -- new horizontal/vertical terminal
--   <A-h> / <A-v> / <A-i>   -- toggleable horizontal/vertical/float terminal
--   <leader>pt              -- telescope picker for hidden terminals
--   <C-x> (terminal mode)   -- escape terminal mode
for _, lhs in ipairs({ "<leader>h", "<leader>v", "<leader>pt" }) do
	pcall(vim.keymap.del, "n", lhs)
end
for _, lhs in ipairs({ "<A-h>", "<A-v>", "<A-i>" }) do
	pcall(vim.keymap.del, { "n", "t" }, lhs)
end
pcall(vim.keymap.del, "t", "<C-x>")

-- Terminal-mode escape: NvChad's own <C-x> escape got dropped above, but
-- :terminal buffers still show up here and there (overseer task output uses
-- a real terminal buffer under the hood -- see overseer.lua's output.use_terminal,
-- and any ad-hoc `:term`/`:vs term://...` split). Without a mapping there's no
-- way back to Normal mode: plain <Esc> is passed straight through to the
-- program running in the terminal, it isn't intercepted by Neovim.
-- <C-\><C-n> is the actual built-in escape sequence; this just binds it to
-- the muscle-memory key.
-- CAVEAT: <C-[> and a literal <Esc> keypress are the exact same byte (0x1B)
-- over a plain terminal connection, so this mapping also fires on plain Esc
-- unless your terminal emulator sends the Kitty keyboard protocol's extended
-- CSI-u encoding to disambiguate them (Kitty/Ghostty/WezTerm with that
-- protocol enabled do; most others don't). If you use a nested TUI program
-- inside the terminal (vim-in-vim, less, fzf, ...) that expects a real Esc,
-- this will exit the outer terminal buffer instead of reaching it -- use
-- <C-\><C-n> directly in that case.
map("t", "<C-[>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- <C-h/j/k/l> tmux-vs-window-nav fix: NvChad core (required above) binds
-- these to plain `<C-w>h/j/k/l` (in-nvim window nav only). tmux.lua's lazy
-- `keys` spec registers vim-tmux-navigator on the same keys, but since it
-- loads *before* this file runs, NvChad's mapping -- set here, later --
-- always wins and silently swallows the tmux side (that's why `<C-l>`
-- wasn't reliably moving into the tmux pane on the right). Re-point them at
-- vim-tmux-navigator explicitly so they stay authoritative regardless of
-- plugin load order.
for key, dir in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
	map("n", "<C-" .. key .. ">", "<cmd>TmuxNavigate" .. dir .. "<cr>", { desc = "tmux/window " .. dir })
end
map("n", "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", { desc = "tmux/window previous" })

-- Ctrl+S: terminals with flow control enabled treat this as XOFF (freeze
-- output until <C-q>), which is very likely the actual cause of the tmux
-- "hanging" -- nvim intercepting <C-s> as save just meant the freeze never
-- got a chance to happen while typing normally, masking the real issue
-- instead of fixing it. Unmap it in nvim (a stray <C-s> now falls through
-- as a no-op key) -- if the freeze still happens outside nvim, add
-- `stty -ixon` to your shell rc too.
for _, mode in ipairs({ "n", "i", "v" }) do
	pcall(vim.keymap.del, mode, "<C-s>")
end

map("n", ";", ":", { desc = "CMD enter command mode" })
pcall(vim.keymap.del, "n", "'")
map("n", "'", "<cmd>Telescope projects<CR>", { desc = "Projects", nowait = true })
map("n", "<leader>aa", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
map("n", "<leader>ae", "<cmd>CopilotChatExplain<CR>", { desc = "Explain with Copilot Chat" })
-- CopilotChat.nvim ships a hardcoded default model in its own config, which
-- can go stale whenever GitHub changes what your account/org actually has
-- access to -- that's the "Model not found" error (typing/sending works
-- fine, it's the model id in the request that's invalid). This asks Copilot
-- for the models actually available right now and lets you pick one.
map("n", "<leader>am", "<cmd>CopilotChatModels<CR>", { desc = "Pick Copilot Chat model" })
map("n", "<leader>dd", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })

map("x", "<leader>ae", "<cmd>CopilotChatExplain<CR>", { desc = "Explain selection with Copilot Chat" })
map("i", "jj", "<ESC>")

map("n", "U", "~h", { desc = "Uppercase first letter of current word" })
map("n", "<leader>u", "g~w", { desc = "Toggle case of word" })

-- buffers
map("n", "<leader>b", "<nop>", { desc = "buffer (disabled)" })
map("n", "<leader>br", function()
	require("nvchad.tabufline").closeBufs_at_direction("right")
end, { desc = "Close buffers right" })
map("n", "<leader>bl", function()
	require("nvchad.tabufline").closeBufs_at_direction("left")
end, { desc = "Close buffers left" })

-- windows
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split window horizontally" })

-- Resize the current split's width. Bound to the physical +/- key (no shift
-- needed, same key), which most terminals report as <C-=>/<C--> regardless
-- of whether shift is held -- if yours reports <C-+> as a distinct key
-- (Kitty/Ghostty/WezTerm with the Kitty keyboard protocol on), that's mapped
-- too so it works either way.
map("n", "<C-=>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<C-+>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<C-->", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- Copilot: nvchad's ai.lua only wires up the chat commands (aa/ae). These
-- lazy-load copilot.lua on first use via its `cmd = "Copilot"` spec, same as
-- lvim -- <leader>at only toggles the ghost-text auto-trigger, not the whole
-- client, that's what <leader>an/<leader>ad are for.
map("n", "<leader>an", "<cmd>Copilot enable<cr>", { desc = "Enable Copilot" })
map("n", "<leader>ad", "<cmd>Copilot disable<cr>", { desc = "Disable Copilot" })
map("n", "<leader>as", "<cmd>Copilot status<cr>", { desc = "Copilot status" })
map("n", "<leader>at", "<cmd>Copilot suggestion toggle_auto_trigger<cr>", { desc = "Toggle Copilot suggestions" })

-- Git-safe Telescope: only run git builtins when inside a git repo
local function git_safe(builtin, desc)
	return function()
		local result = vim.fn.systemlist("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse --git-dir 2>/dev/null")
		if vim.v.shell_error ~= 0 or #result == 0 then
			vim.notify("Not a git directory", vim.log.levels.WARN, { title = "Telescope" })
			return
		end
		require("telescope.builtin")[builtin]()
	end
end

-- Override NvChad's default git telescope mappings
map("n", "<leader>cm", git_safe("git_commits", "telescope git commits"), { desc = "telescope git commits" })
map("n", "<leader>gt", git_safe("git_status", "telescope git status"), { desc = "telescope git status" })

-- LSP code actions (buffer-local, active only when LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		-- Code actions
		map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
		map("x", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action (range)" }))

		-- Quick-fix (apply first available code action)
		map("n", "<leader>cq", function()
			vim.lsp.buf.code_action({ apply = true })
		end, vim.tbl_extend("force", opts, { desc = "Quick-fix (apply first action)" }))

		-- Rename symbol
		map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

		-- Go-to definitions / references
		map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
		map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
		map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
		map("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
		pcall(vim.keymap.del, "n", "<leader>D", { buffer = ev.buf }) -- duplicate of gy

		-- Hover / signature
		map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
		map("n", "<leader>sh", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

		-- Inlay hints (param names, inferred types, ...): both gopls and tsgo
		-- are configured with hint settings in configs/lspconfig.lua, but that
		-- alone doesn't display anything -- it has to be enabled client-side too.
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(inlay_hints_default(), { bufnr = ev.buf })
		end
		map("n", "<leader>ci", function()
			local bufnr = ev.buf
			local enabled = not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
			vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
			inlay_hints_save(enabled)
		end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))

		-- Diagnostics
		map("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
		map("n", "[d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
		map("n", "]d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
		map("n", "<leader>ce", function()
			vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
		end, vim.tbl_extend("force", opts, { desc = "Next error" }))

		-- Workspace folders
		map(
			"n",
			"<leader>wa",
			vim.lsp.buf.add_workspace_folder,
			vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
		)
		map("n", "<leader>wl", function()
			-- No builtin telescope picker for this -- list_workspace_folders() is
			-- just a plain string list, so a minimal pickers/finders/sorter picker
			-- is all it needs.
			require("telescope.pickers")
				.new({}, {
					prompt_title = "LSP Workspace Folders",
					finder = require("telescope.finders").new_table({
						results = vim.lsp.buf.list_workspace_folders(),
					}),
					sorter = require("telescope.config").values.generic_sorter({}),
				})
				:find()
		end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
	end,
})
