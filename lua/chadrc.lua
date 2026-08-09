-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "chadracula",
	transparency = true,

	hl_override = {
		Comment = { italic = true },
		["@comment"] = { italic = true },
	},
}

M.nvdash = { load_on_startup = true }

-- NvChad's own au.lua wires an LSP-agnostic autocmd that fires
-- `vim.lsp.buf.signature_help()` on every `TextChangedI` next to a trigger
-- character (see NvChad/ui lua/nvchad/lsp/signature.lua) -- that's the
-- "Signature Help: tsgo (1/9) (<C-s> to cycle)" float that pops up
-- unprompted while typing a call, tsgo included, since tsgo reports every
-- overload as a separate signature. Turning this off doesn't lose the
-- feature -- `<leader>sh` (mappings.lua) still calls the same function
-- on demand, it just stops firing itself on every keystroke.
M.lsp = { signature = false }

M.ui = {
	statusline = {
		theme = "default",
		separator_style = "round",
	},

	tabufline = {
		order = { "buffers", "tabs", "btns", "treeOffset" },
		lazyload = false,
	},
}

return M
