require "nvchad.options"

local o = vim.o
local opt = vim.opt

o.cursorline = false -- matches lvim -- no highlighted current line
o.cursorlineopt = "number" -- moot while cursorline is off, kept for parity with lvim
opt.termguicolors = true -- Enable 24-bit RGB colors in the terminal
opt.background = "dark" -- Force dark version of colorschemes
opt.signcolumn = "yes" -- Always show the sign column (prevents text from shifting when git signs appear)
opt.guicursor = ""
opt.scrolloff = 6 -- keep 8 lines of context above/below the cursor -- matches lvim

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
