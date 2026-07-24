require "nvchad.options"

local o = vim.o
local opt = vim.opt

-- UI & Display Settings
o.cursorlineopt = "both" -- Highlight both the line number and the line itself
opt.laststatus = 3 -- Global statusline (only one statusline at the bottom instead of one per split)
opt.termguicolors = true -- Enable 24-bit RGB colors in the terminal
opt.background = "dark" -- Force dark version of colorschemes
opt.signcolumn = "yes" -- Always show the sign column (prevents text from shifting when git signs appear)
opt.guicursor = ""

-- Wrapping & Text Formatting
opt.wrap = true -- Visually wrap long lines
opt.linebreak = true -- Don't break words in the middle when wrapping (companion to wrap)

-- Search Behavior
opt.ignorecase = true -- Case-insensitive searching by default
opt.smartcase = true -- Automatically switch to case-sensitive if you type a capital letter

-- Window Splitting Behavior
opt.splitright = true -- New vertical splits will open to the right
opt.splitbelow = true -- New horizontal splits will open at the bottom

-- Performance & Files
opt.updatetime = 250 -- Faster completion times and CursorHold events (default is 4000ms)
opt.swapfile = false -- Disable creating annoying .swp files
