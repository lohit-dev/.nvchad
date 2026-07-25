return {
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = function(_, opts)
      opts = opts or {}
      opts.plugins = vim.tbl_deep_extend("force", opts.plugins or {}, {
        marks = false,
      })
      -- Always show at the bottom
      opts.win = vim.tbl_deep_extend("force", opts.win or {}, {
        row = vim.o.lines,
      })
      -- Group labels for every <leader> prefix
      opts.spec = {
        -- AI
        { "<leader>a", group = "󰭹 AI (Copilot)" },
        { "<leader>aa", desc = "Toggle chat" },
        { "<leader>ae", desc = "Explain selection" },

        -- Buffers
        { "<leader>b", group = "󰓩 Buffers" },
        { "<leader>br", desc = "Close right" },
        { "<leader>bl", desc = "Close left" },
        { "<leader>x", desc = "Close buffer" },

        -- Code / LSP
        { "<leader>c", group = " Code & LSP" },
        { "<leader>ca", desc = "Code action" },
        { "<leader>cq", desc = "Quick-fix (apply first)" },
        { "<leader>cd", desc = "Line diagnostics" },
        { "<leader>ce", desc = "Next error" },
        { "<leader>ch", desc = "Cheatsheet" },
        { "<leader>cm", desc = "Git commits" },

        -- Diff
        { "<leader>d", group = " Diff" },
        { "<leader>dd", desc = "Open diffview" },
        { "<leader>ds", desc = "Diagnostic loclist" },

        -- Explorer / Editor
        { "<leader>e", desc = "󰙅 File explorer" },

        -- Find (Telescope)
        { "<leader>f", group = " Find (Telescope)" },
        { "<leader>ff", desc = "Find files" },
        { "<leader>fw", desc = "Live grep" },
        { "<leader>fb", desc = "Buffers" },
        { "<leader>fh", desc = "Help tags" },
        { "<leader>fo", desc = "Recent files" },
        { "<leader>fz", desc = "Fuzzy (current buffer)" },

        -- Git (Telescope)
        { "<leader>g", group = " Git" },
        { "<leader>gt", desc = "Status" },

        -- Hunks (Gitsigns)
        { "<leader>h", group = "󰊢 Hunks (Gitsigns)" },
        { "<leader>hs", desc = "Stage hunk" },
        { "<leader>hr", desc = "Reset hunk" },
        { "<leader>hu", desc = "Undo stage hunk" },
        { "<leader>hS", desc = "Stage buffer" },
        { "<leader>hR", desc = "Reset buffer" },
        { "<leader>hp", desc = "Preview hunk" },
        { "<leader>hb", desc = "Blame line" },

        -- Marks
        { "<leader>m", group = "󰃃 Marks" },
        { "<leader>ma", desc = "Find marks" },

        -- Toggle
        { "<leader>n", desc = "󰿠 Toggle line numbers" },

        -- Picker (terminal)
        { "<leader>p", group = " Pick" },
        { "<leader>pt", desc = "Pick terminal" },

        -- Rename / Relative numbers
        { "<leader>r", group = " Rename / Numbers" },
        { "<leader>rn", desc = "Rename symbol" },

        -- Signature / Search
        { "<leader>s", group = "󰍉 Signature / Search" },
        { "<leader>sh", desc = "Signature help" },

        -- Theme
        { "<leader>t", group = "󰏘 Theme" },
        { "<leader>th", desc = "Change theme" },

        -- Misc
        { "<leader>u", desc = "󰅨 Toggle case of word" },

        -- Splits
        { "<leader>v", desc = " Vertical split" },
        { "<leader>h", desc = " Horizontal split" },

        -- Windows / WhichKey
        { "<leader>w", group = "󱂬 Windows" },
        { "<leader>w=", desc = "Equalize splits" },
        { "<leader>wK", desc = "All keymaps" },
        { "<leader>wk", desc = "WhichKey for keymap" },

        -- Close buffer
        { "<leader>x", desc = "󰅙 Close buffer" },
      }
      return opts
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
      pcall(vim.keymap.del, "n", "'")
    end,
  },
}
