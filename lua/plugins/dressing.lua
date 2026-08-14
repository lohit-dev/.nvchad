return {
  "stevearc/dressing.nvim",
  -- Lazy-loads itself off vim.ui.select/vim.ui.input the first time
  -- anything calls them, per the plugin's own README -- code_action pickers,
  -- rename prompts, GoImpl's interface picker, telescope-less confirm
  -- dialogs, etc. all route through those two, so no event/ft/cmd trigger
  -- needed here.
  lazy = true,
  opts = {},
}
