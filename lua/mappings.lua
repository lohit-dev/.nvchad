require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
pcall(vim.keymap.del, "n", "'")
map("n", "'", "<cmd>Telescope projects<CR>", { desc = "Projects", nowait = true })
map("n", "<leader>aa", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle Copilot Chat" })
map("n", "<leader>ae", "<cmd>CopilotChatExplain<CR>", { desc = "Explain with Copilot Chat" })
map("n", "<leader>dd", "<cmd>DiffviewOpen<CR>", { desc = "Open diffview" })
map("x", "<leader>ae", "<cmd>CopilotChatExplain<CR>", { desc = "Explain selection with Copilot Chat" })
map("i", "jj", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "U", "~h", { desc = "Uppercase first letter of current word" })
map("n", "<leader>u", "g~w", { desc = "Toggle case of word" })

-- buffers
map("n", "<leader>b", "<nop>", { desc = "buffer (disabled)" })
map("n", "<leader>br", function()
  require("nvchad.tabufline").closeBufs_at_direction "right"
end, { desc = "Close buffers right" })
map("n", "<leader>bl", function()
  require("nvchad.tabufline").closeBufs_at_direction "left"
end, { desc = "Close buffers left" })

-- windows
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize splits" })
