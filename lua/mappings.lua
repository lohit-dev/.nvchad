require "nvchad.mappings"
local map = vim.keymap.set

-- General
map("n", ";", ":", { desc = "Command mode" })
map("i", "jj", "<ESC>", { desc = "Exit insert" })
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })
map("n", "<A-h>", "<cmd>vertical resize -1<cr>", { desc = "Resize width -" })
map("n", "<A-l>", "<cmd>vertical resize +1<cr>", { desc = "Resize width +" })
map("n", "<leader>fp", "<cmd>Telescope projects<cr>", { desc = "Find projects" })

-- Cursor Agent (keymaps here so which-key picks them up)
map("n", "<leader>ca", "<cmd>CursorAgent<cr>", { desc = "Toggle terminal" })
map("v", "<leader>ca", "<cmd>CursorAgentSelection<cr>", { desc = "Send selection" })
map("n", "<leader>cA", "<cmd>CursorAgentBuffer<cr>", { desc = "Send buffer" })

-- Buffer (tabufline)
map("n", "<leader>b", "<nop>", { desc = "buffer (disabled)" })
map("n", "<leader>br", function()
  require("nvchad.tabufline").closeBufs_at_direction "right"
end, { desc = "Close buffers right" })
map("n", "<leader>bl", function()
  require("nvchad.tabufline").closeBufs_at_direction "left"
end, { desc = "Close buffers left" })
map("n", "<leader>bt", function()
  vim.o.showtabline = vim.o.showtabline == 2 and 0 or 2
end, { desc = "Toggle tabline" })

-- Harpoon
map("n", "<leader>ja", function()
  require("harpoon"):list():add()
end, { desc = "Harpoon add" })
map("n", "<leader>mm", function()
  local h = require "harpoon"
  h.ui:toggle_quick_menu(h:list())
end, { desc = "Harpoon menu" })
for i = 1, 4 do
  map("n", "<leader>" .. i, function()
    require("harpoon"):list():select(i)
  end, { desc = "Harpoon file " .. i })
end

-- Leetcode
map("n", "<leader>ll", "<cmd>Leet<cr>", { desc = "Leetcode home" })
map("n", "<leader>ld", "<cmd>Leet daily<cr>", { desc = "Leetcode daily" })
map("n", "<leader>lr", "<cmd>Leet run<cr>", { desc = "Leetcode run" })
map("n", "<leader>ls", "<cmd>Leet submit<cr>", { desc = "Leetcode submit" })
