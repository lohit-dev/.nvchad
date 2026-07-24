return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      {
        "zbirenbaum/copilot.lua",
        dependencies = {
          "copilotlsp-nvim/copilot-lsp",
        },
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup {
            panel = {
              enabled = false,
            },
            suggestion = {
              enabled = true,
              auto_trigger = true,
              hide_during_completion = true,
              keymap = {
                accept = "<Tab>",
              },
            },
          }

          vim.api.nvim_create_autocmd("User", {
            pattern = "BlinkCmpMenuOpen",
            callback = function()
              vim.b.copilot_suggestion_hidden = true
            end,
          })

          vim.api.nvim_create_autocmd("User", {
            pattern = "BlinkCmpMenuClose",
            callback = function()
              vim.b.copilot_suggestion_hidden = false
            end,
          })
        end,
      },
    },
    cmd = {
      "CopilotChat",
      "CopilotChatOpen",
      "CopilotChatClose",
      "CopilotChatToggle",
      "CopilotChatStop",
      "CopilotChatReset",
      "CopilotChatSave",
      "CopilotChatLoad",
      "CopilotChatPrompts",
      "CopilotChatModels",
      "CopilotChatExplain",
    },
    build = "make tiktoken",
    opts = {},
  },
}
