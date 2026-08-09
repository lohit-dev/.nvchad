-- Disables the vertical indent-guide lines (the "│" glyphs running down
-- every scope) that NvChad's base ships by default via this same plugin.
-- Overriding the same plugin URL here merges with (and turns off) the base
-- spec instead of duplicating it.
return {
	{ "lukas-reineke/indent-blankline.nvim", enabled = false },
}
