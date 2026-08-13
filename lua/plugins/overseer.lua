return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerShell" },
    keys = { "<leader>ot", "<leader>or", "<leader>oc" },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 20,
        max_height = 20,
        default_detail = 1,
      },
    },
    config = function(_, opts)
      require("overseer").setup(opts)

      vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })

      -- Close the vsplit from the last <leader>or run before opening a new
      -- one, so repeat runs replace the output in place instead of stacking
      -- vsplits sideways forever.
      local last_output_win = nil

      vim.keymap.set("n", "<leader>or", function()
        require("overseer").run_task({}, function(task, err)
          if err then
            vim.notify(err, vim.log.levels.ERROR)
            return
          end
          if not task then
            return
          end
          if last_output_win and vim.api.nvim_win_is_valid(last_output_win) then
            vim.api.nvim_win_close(last_output_win, true)
          end
          require("overseer").run_action(task, "open vsplit")
          last_output_win = vim.api.nvim_get_current_win()
        end)
      end, { desc = "Run task (vsplit output)" })

      vim.keymap.set("n", "<leader>oc", ":OverseerShell ", { desc = "Run custom task command" })

      -- Task output buffers are filetype "OverseerOutput" -- scope
      -- `q`-to-close to just those, so it doesn't hijack macro recording
      -- anywhere else.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "OverseerOutput",
        callback = function(args)
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true, desc = "Close task output" })
        end,
      })
    end,
  },
}
