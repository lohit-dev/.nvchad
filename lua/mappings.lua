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

-- Git-safe Telescope: only run git builtins when inside a git repo
local function git_safe(builtin, desc)
  return function()
    local result = vim.fn.systemlist("git -C " .. vim.fn.expand "%:p:h" .. " rev-parse --git-dir 2>/dev/null")
    if vim.v.shell_error ~= 0 or #result == 0 then
      vim.notify("Not a git directory", vim.log.levels.WARN, { title = "Telescope" })
      return
    end
    require("telescope.builtin")[builtin]()
  end
end

-- Override NvChad's default git telescope mappings
map("n", "<leader>cm", git_safe("git_commits", "telescope git commits"), { desc = "telescope git commits" })
map("n", "<leader>gt", git_safe("git_status", "telescope git status"), { desc = "telescope git status" })

-- LSP code actions (buffer-local, active only when LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- Code actions
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
    map("x", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action (range)" }))

    -- Quick-fix (apply first available code action)
    map("n", "<leader>cq", function()
      vim.lsp.buf.code_action { apply = true }
    end, vim.tbl_extend("force", opts, { desc = "Quick-fix (apply first action)" }))

    -- Rename symbol
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

    -- Go-to definitions / references
    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to references" }))
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
    map("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to type definition" }))
    pcall(vim.keymap.del, "n", "<leader>D", { buffer = ev.buf }) -- duplicate of gy

    -- Hover / signature
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
    map("n", "<leader>sh", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

    -- Diagnostics
    map("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
    map("n", "[d", function()
      vim.diagnostic.jump { count = -1, float = true }
    end, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))
    map("n", "]d", function()
      vim.diagnostic.jump { count = 1, float = true }
    end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
    map("n", "<leader>ce", function()
      vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR, float = true }
    end, vim.tbl_extend("force", opts, { desc = "Next error" }))
  end,
})
