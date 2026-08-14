local parsers = {
  "vim",
  "lua",
  "vimdoc",
  "html",
  "tsx",
  "markdown",
  "markdown_inline",
  "css",
  "go",
  "rust",
  "typescript",
  "javascript",
  "java",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- This repo tracks nvim-treesitter's `main` branch (the full rewrite,
    -- incompatible with the old `master` branch API) -- confirmed via
    -- lazy-lock.json / the plugin's own README banner. Two things changed
    -- that silently broke parser installs here:
    --
    -- 1. `opts = { ensure_installed = {...} }` is gone. The old branch's
    --    `require("nvim-treesitter.configs").setup(opts)` accepted that
    --    key and installed parsers on startup; the rewritten `setup()`
    --    only takes `install_dir`. Passing `ensure_installed` in opts
    --    isn't an error -- it's just an unused table key -- so lazy.nvim's
    --    automatic `require("nvim-treesitter").setup(opts)` silently did
    --    nothing, and NO parser (go, rust, java, none of them) was ever
    --    actually being installed. Confirmed by testing: opening a .go
    --    file had zero highlighting, and every go.nvim treesitter-query
    --    feature (:GoAddTag, struct detection, etc.) failed outright with
    --    "Unable to find any nodes" because there was no `go` parser on
    --    disk to query in the first place.
    -- 2. The README now explicitly says lazy-loading isn't supported and
    --    recommends `lazy = false, build = ":TSUpdate"` -- `:TSUpdate`
    --    updates whatever's already installed, so it only actually pulls
    --    parsers in the first place if something has separately requested
    --    them, which is what the `install()` call below is for.
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(parsers)

      -- The rewrite also stopped auto-starting highlighting (README:
      -- "These are not automatically enabled") -- previously the old
      -- branch's `highlight = { enable = true }` opt did this for you.
      -- NvChad's base config may already do this in newer versions, but
      -- it's cheap and idempotent to make sure explicitly rather than
      -- relying on that.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function(args)
          -- pcall: harmless no-op for filetypes where the parser install
          -- above is still running asynchronously in the background the
          -- very first time a matching buffer is opened.
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  },
}
