local telescope = require "telescope"
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    -- Show hidden files (dotfiles like .env, .eslintrc, etc.)
    -- and files listed in .gitignore
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",        -- include hidden files in live_grep
      "--glob=!.git/**", -- but still exclude .git internals
    },
  },
  pickers = {
    find_files = {
      hidden = true,        -- show dotfiles / hidden files
      no_ignore = false,    -- still respect .gitignore for everything else…
      no_ignore_parent = false,
      -- override specifically for find_files so .env shows up:
      find_command = {
        "fd",
        "--type", "f",
        "--hidden",          -- include hidden files
        "--no-ignore",       -- don't skip .gitignore entries (shows .env etc.)
        "--exclude", ".git", -- but always exclude .git directory
      },
    },
  },
}
