-- Chat/explain-in-buffer AI, replacing CopilotChat. Only needs an
-- OPENAI_API_KEY env var (or `openai_api_key_cmd` below) -- no separate
-- GitHub Copilot subscription/auth required for this part.
return {
  {
    "jackMort/ChatGPT.nvim",
    cmd = {
      "ChatGPT",
      "ChatGPTActAs",
      "ChatGPTEditWithInstructions",
      "ChatGPTRun",
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      { "nvim-lua/plenary.nvim", branch = "master" },
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("chatgpt").setup {
        -- api_key_cmd = "op read op://Private/openai-api-key/credential --no-newline",
      }
    end,
  },
}
