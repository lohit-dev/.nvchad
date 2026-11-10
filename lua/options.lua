require "nvchad.options"

local o = vim.o
local opt = vim.opt

-- Compose files use a dedicated LSP; share the YAML Treesitter parser with them.
vim.filetype.add {
  filename = {
    ["compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["docker-compose.yml"] = "yaml.docker-compose",
  },
  pattern = {
    ["docker%-compose.*%.ya?ml"] = "yaml.docker-compose",
    ["compose.*%.ya?ml"] = "yaml.docker-compose",
  },
}
vim.treesitter.language.register("yaml", "yaml.docker-compose")

-- Keep comments on one line: don't continue leaders on Enter or o/O, and don't
-- auto-wrap comment text. Reapply locally in case a filetype plugin adds them.
opt.formatoptions:remove({ "c", "r", "o" })
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("DisableCommentContinuation", { clear = true }),
  callback = function(args)
    vim.bo[args.buf].formatoptions = vim.bo[args.buf].formatoptions:gsub("[cro]", "")
  end,
})

o.cursorline = false -- matches lvim -- no highlighted current line
o.cursorlineopt = "number" -- moot while cursorline is off, kept for parity with lvim
o.winborder = "rounded" -- rounded borders for floating windows
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
