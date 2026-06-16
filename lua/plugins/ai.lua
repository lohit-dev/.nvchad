return {
  {
    "xTacobaco/cursor-agent.nvim",
    lazy = false,
    config = function()
      require("cursor-agent").setup { cmd = "cursor-agent", args = {} }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
      {
        "zbirenbaum/copilot.lua",
        requires = {
          "copilotlsp-nvim/copilot-lsp",
        },
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
          require("copilot").setup {
            suggestion = {
              enabled = true,
              auto_trigger = true,
              keymap = {
                accept = "<S-Cr>",
              },
            },
          }
        end,
      },
    },
    build = "make tiktoken",
    opts = {},
  },
  -- {
  --   "yetone/avante.nvim",
  --   build = vim.fn.has("win32") ~= 0
  --       and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
  --       or "make",
  --   event = "VeryLazy",
  --   version = false,
  --   opts = {
  --     debug = true, -- Enable debug mode to troubleshoot credentials
  --     instructions_file = "avante.md",
  --     provider = "gemini",
  --     mode = "agentic", -- Default interaction mode
  --     providers = {
  --       gemini = {
  --         endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
  --         model = "gemini-2.0-flash",
  --         api_key_name = "AVANTE_GEMINI_API_KEY",
  --         timeout = 30000,
  --         context_window = 1048576,
  --         use_ReAct_prompt = true,
  --         extra_request_body = {
  --           generationConfig = {
  --             temperature = 0.75,
  --           },
  --         },
  --       },
  --       openai = {
  --         endpoint = "https://api.openai.com/v1",
  --         model = "gpt-4o-mini",
  --         api_key_name = "AVANTE_OPENAI_API_KEY",
  --         timeout = 30000,
  --         context_window = 128000,
  --         extra_request_body = {
  --           temperature = 0.75,
  --           max_completion_tokens = 16384,
  --         },
  --       },
  --       deepseek = {
  --         __inherited_from = "openai",
  --         endpoint = "https://api.deepseek.com/v1",
  --         model = "deepseek-chat",
  --         api_key_name = "AVANTE_DEEPSEEK_API_KEY",
  --         timeout = 30000,
  --       },
  --       cohere = {
  --         endpoint = "https://api.cohere.ai/v2",
  --         model = "command-r-plus-08-2024",
  --         api_key_name = "AVANTE_COHERE_API_KEY",
  --         timeout = 30000,
  --         extra_request_body = {
  --           temperature = 0.75,
  --           max_tokens = 20480,
  --         },
  --       },
  --       groq = {
  --         __inherited_from = "openai",
  --         endpoint = "https://api.groq.com/openai/v1",
  --         model = "llama-3.3-70b-versatile",
  --         api_key_name = "AVANTE_GROQ_API_KEY",
  --         timeout = 30000,
  --       },
  --     },
  --     behaviour = {
  --       auto_suggestions = false,
  --       auto_set_highlight_group = true,
  --       auto_set_keymaps = true,
  --       auto_apply_diff_after_generation = false,
  --       support_paste_from_clipboard = false,
  --       minimize_diff = true,
  --       enable_token_counting = true,
  --       auto_add_current_file = true,
  --       auto_approve_tool_permissions = true,
  --     },
  --   },
  --   config = function(_, opts)
  --     local function set_env_from_pass(env_var, pass_path)
  --       local handle = io.popen("pass show " .. pass_path .. " 2>/dev/null")
  --       if handle then
  --         local key = handle:read("*a")
  --         handle:close()
  --         key = key:gsub("%s+$", "")
  --         if key ~= "" then
  --           vim.fn.setenv(env_var, key)
  --           print("✓ Loaded", env_var, ":", key:sub(1, 10) .. "...")
  --         else
  --           print("✗ Failed to load", env_var, "from pass")
  --         end
  --       end
  --     end
  --
  --     set_env_from_pass("AVANTE_GEMINI_API_KEY", "keys/gemini")
  --
  --     -- Verify after setup
  --     local loaded_key = vim.fn.getenv("AVANTE_GEMINI_API_KEY")
  --     if loaded_key ~= vim.NIL then
  --       print("✓ AVANTE_GEMINI_API_KEY is set:", loaded_key:sub(1, 10) .. "...")
  --     else
  --       print("✗ AVANTE_GEMINI_API_KEY is NOT set")
  --     end
  --
  --     require("avante").setup(opts)
  --   end,
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     "nvim-mini/mini.pick",
  --     "nvim-telescope/telescope.nvim",
  --     "saghen/blink.cmp",
  --     "ibhagwan/fzf-lua",
  --     "stevearc/dressing.nvim",
  --     "folke/snacks.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     "zbirenbaum/copilot.lua",
  --     {
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  -- }
}
