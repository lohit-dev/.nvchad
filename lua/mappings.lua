require("nvchad.mappings")

local map = vim.keymap.set

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

-- <C-h/j/k/l> tmux-vs-window-nav fix: NvChad core (required above) binds
-- these to plain `<C-w>h/j/k/l` (in-nvim window nav only). tmux.lua's lazy
-- `keys` spec registers vim-tmux-navigator on the same keys, but since it
-- loads *before* this file runs, NvChad's mapping -- set here, later --
-- always wins and silently swallows the tmux side (that's why `<C-l>`
-- wasn't reliably moving into the tmux pane on the right). Re-point them at
-- vim-tmux-navigator explicitly so they stay authoritative regardless of
-- plugin load order.
for key, dir in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
	map("n", "<C-" .. key .. ">", "<cmd><C-U>TmuxNavigate" .. dir .. "<cr>", { desc = "tmux/window " .. dir })
end
map("n", "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { desc = "tmux/window previous" })

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

-- LeetCode (plugin already ships via extras.lua, just wasn't bound to keys).
--
-- leetcode.nvim refuses to start ("Failed to initialize: `neovim` contains
-- listed buffers") unless there are zero listed buffers open -- that's the
-- plugin's own documented requirement, not a config issue. This helper
-- closes any unmodified listed buffers before launching so the keymap just
-- works from wherever you are; if something has unsaved changes it warns
-- instead of discarding your work.
local function leet(subcmd)
	return function()
		local dirty = {}
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
				if vim.bo[buf].modified then
					table.insert(dirty, vim.api.nvim_buf_get_name(buf))
				else
					vim.api.nvim_buf_delete(buf, {})
				end
			end
		end
		if #dirty > 0 then
			vim.notify(
				"LeetCode needs no buffers open -- save/close first:\n" .. table.concat(dirty, "\n"),
				vim.log.levels.WARN
			)
			return
		end
		vim.cmd("Leet " .. subcmd)
	end
end

map("n", "<leader>ll", leet(""), { desc = "LeetCode menu" })
map("n", "<leader>ld", leet("daily"), { desc = "LeetCode daily" })
map("n", "<leader>lr", leet("random"), { desc = "LeetCode random" })
map("n", "<leader>lt", "<cmd>Leet test<cr>", { desc = "LeetCode test" })
map("n", "<leader>ls", "<cmd>Leet submit<cr>", { desc = "LeetCode submit" })
map("n", "<leader>lo", leet("list"), { desc = "LeetCode problem list" })
map("n", "<leader>li", "<cmd>Leet tabs<cr>", { desc = "LeetCode switch tabs" })

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

-- gopls exposes a handful of "web" actions in the same list as real code
-- actions -- browse arm64 assembly, browse pkg.go.dev docs, split package
-- (opens a browser diff), toggle compiler-opt-details (opens a browser
-- tab). None of these are ever useful from the code-action menu: docs are
-- one `K` away for whatever's under the cursor. Filtered by `kind` (stable
-- across gopls versions) so the real quickfix/refactor/organizeImports
-- actions still show up.
local noisy_action_kinds = {
	["source.assembly"] = true,
	["source.doc"] = true,
	["source.freesymbols"] = true,
	["source.splitPackage"] = true,
	["source.toggleCompilerOptDetails"] = true,
	["gopls.doc.features"] = true,
}

-- gopher.nvim's GoTagAdd/GoTagRm/GoTestAdd/GoImpl/GoJson/GoCmt/GoGenerate
-- have no LSP-side equivalent gopls could ever surface as a code action, so
-- they're listed here as plain commands and merged into the same menu
-- below -- one place to pick an action instead of a real code action list
-- plus a separate set of keybindings to remember.
local function gopher_actions()
	local function run(cmd)
		return function()
			vim.cmd(cmd)
		end
	end
	return {
		{ title = "Add json struct tags", run = run("GoTagAdd json") },
		{ title = "Add yaml struct tags", run = run("GoTagAdd yaml") },
		{ title = "Add validate struct tags", run = run("GoTagAdd validate") },
		{ title = "Remove json struct tags", run = run("GoTagRm json") },
		{ title = "Add test for func under cursor", run = run("GoTestAdd") },
		{ title = "Add tests for all funcs in file", run = run("GoTestsAll") },
		{ title = "Add tests for exported funcs", run = run("GoTestsExp") },
		{ title = "JSON -> Go struct", run = run("GoJson") },
		{ title = "Generate doc comment", run = run("GoCmt") },
		{ title = "go generate (current package)", run = run("GoGenerate") },
		{
			title = "Implement interface...",
			run = function()
				vim.ui.input({ prompt = "Implement interface (e.g. io.Reader): " }, function(iface)
					if iface and #iface > 0 then
						vim.cmd("GoImpl " .. iface)
					end
				end)
			end,
		},
	}
end

-- Faithful trim of Neovim core's vim.lsp.buf.code_action (see
-- runtime/lua/vim/lsp/buf.lua) -- same request/resolve/apply flow, but
-- filters noisy gopls actions and, in Go buffers, merges gopher.nvim's
-- commands into the same vim.ui.select menu so there's one place to pick
-- an action from.
local function code_action(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
	local extra = vim.bo[bufnr].filetype == "go" and gopher_actions() or {}

	local function show(results)
		local items = {}
		for _, result in pairs(results) do
			for _, action in pairs(result.result or {}) do
				if not noisy_action_kinds[action.kind] then
					table.insert(items, { title = action.title, lsp_action = action, ctx = result.ctx })
				end
			end
		end
		for _, a in ipairs(extra) do
			table.insert(items, a)
		end
		if #items == 0 then
			vim.notify("No code actions available", vim.log.levels.INFO)
			return
		end
		vim.ui.select(items, {
			prompt = "Code actions:",
			kind = "codeaction",
			format_item = function(item)
				return item.title
			end,
		}, function(choice)
			if not choice then
				return
			end
			if choice.run then
				choice.run()
				return
			end
			local client = assert(vim.lsp.get_client_by_id(choice.ctx.client_id))
			local action = choice.lsp_action
			local function apply(a)
				if a.edit then
					vim.lsp.util.apply_workspace_edit(a.edit, client.offset_encoding)
				end
				if a.command then
					local command = type(a.command) == "table" and a.command or a
					client:exec_cmd(command, choice.ctx)
				end
			end
			if type(action.title) == "string" and type(action.command) == "string" then
				apply(action)
				return
			end
			if not (action.edit and action.command) and client:supports_method("codeAction/resolve") then
				client:request("codeAction/resolve", action, function(err, resolved)
					if err then
						if action.edit or action.command then
							apply(action)
						else
							vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
						end
					else
						apply(resolved)
					end
				end, choice.ctx.bufnr)
			else
				apply(action)
			end
		end)
	end

	if #clients == 0 then
		show({})
		return
	end

	local results, remaining = {}, #clients
	for _, client in ipairs(clients) do
		local params = vim.lsp.util.make_range_params(win, client.offset_encoding)
		params.context = { triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked }
		client:request("textDocument/codeAction", params, function(err, result, ctx)
			results[ctx.client_id] = { error = err, result = result, ctx = ctx }
			remaining = remaining - 1
			if remaining == 0 then
				show(results)
			end
		end, bufnr)
	end
end

-- LSP code actions (buffer-local, active only when LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
	callback = function(ev)
		local opts = { buffer = ev.buf, silent = true }

		-- Code actions
		map("n", "<leader>ca", function()
			code_action()
		end, vim.tbl_extend("force", opts, { desc = "Code action" }))
		map("x", "<leader>ca", function()
			code_action()
		end, vim.tbl_extend("force", opts, { desc = "Code action (range)" }))

		-- Quick-fix (apply first available *LSP* action -- gopher commands
		-- aren't "fixes" for anything under the cursor, so they're deliberately
		-- left out of this one; use <leader>ca for those)
		map("n", "<leader>cq", function()
			vim.lsp.buf.code_action({
				apply = true,
				filter = function(action)
					return not noisy_action_kinds[action.kind]
				end,
			})
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
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
		map("n", "<leader>ci", function()
			local bufnr = ev.buf
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
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
