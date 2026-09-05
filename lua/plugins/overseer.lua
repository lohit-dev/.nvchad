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
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 20,
        max_height = 20,
        default_detail = 1,
      },
    },
  },
}
