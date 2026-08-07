return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open Lazygit" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "-" },
        topdelete = { text = "-" },
        changedelete = { text = "~" },
        untracked = { text = "+" },
      },
      on_attach = function(buf)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        local o = { buffer = buf, silent = true }

        -- Navigate hunks
        map("n", "]h", gs.next_hunk, vim.tbl_extend("force", o, { desc = "Next hunk" }))
        map("n", "[h", gs.prev_hunk, vim.tbl_extend("force", o, { desc = "Prev hunk" }))

        -- Stage / reset
        map("n", "<leader>hs", gs.stage_hunk, vim.tbl_extend("force", o, { desc = "Stage hunk" }))
        map("n", "<leader>hr", gs.reset_hunk, vim.tbl_extend("force", o, { desc = "Reset hunk" }))
        map("n", "<leader>hu", gs.undo_stage_hunk, vim.tbl_extend("force", o, { desc = "Undo stage hunk" }))
        map("n", "<leader>hS", gs.stage_buffer, vim.tbl_extend("force", o, { desc = "Stage buffer" }))
        map("n", "<leader>hR", gs.reset_buffer, vim.tbl_extend("force", o, { desc = "Reset buffer" }))

        -- Preview / blame
        map("n", "<leader>hp", gs.preview_hunk, vim.tbl_extend("force", o, { desc = "Preview hunk" }))
        map("n", "<leader>hb", function()
          gs.blame_line { full = true }
        end, vim.tbl_extend("force", o, { desc = "Blame line" }))
      end,
    },
  },
}
