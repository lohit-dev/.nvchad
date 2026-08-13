require "nvchad.options"

local o = vim.o
local opt = vim.opt

-- UI & Display Settings
o.cursorline = false -- matches lvim -- no highlighted current line
o.cursorlineopt = "number" -- moot while cursorline is off, kept for parity with lvim
opt.laststatus = 3 -- One global statusline -- nvchad's default; renders the round/bubble
-- separator style from chadrc.lua's `M.ui.statusline`
opt.cmdheight = 0 -- No command-line row either, same minimal-chrome look as lvim
opt.termguicolors = true -- Enable 24-bit RGB colors in the terminal
opt.background = "dark" -- Force dark version of colorschemes
opt.signcolumn = "yes" -- Always show the sign column (prevents text from shifting when git signs appear)
opt.guicursor = ""
opt.scrolloff = 8 -- keep 8 lines of context above/below the cursor -- matches lvim
opt.shortmess:append "W" -- suppress "written" messages on save, on top of base's "sI"

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

-- matches lvim's completeopt (nvim-cmp usually sets its own at runtime too,
-- this just makes the intent explicit / applies outside cmp's own popups)
opt.completeopt = { "menuone", "noinsert" }
