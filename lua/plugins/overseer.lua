return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerBuild",
      "OverseerInfo",
      "OverseerRun",
      "OverseerRunCmd",
      "OverseerTaskAction",
      "OverseerToggle",
    },
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Overseer: Run task" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Overseer: Toggle tasks" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>", desc = "Overseer: Task action" },
      { "<leader>oc", "<cmd>OverseerRunCmd<cr>", desc = "Overseer: Run command" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer: Info" },
    },
    opts = {
      task_list = {
        direction = "right",
        min_width = { 40, 0.2 },
      },
    },
  },
}
