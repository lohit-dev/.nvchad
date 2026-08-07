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
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split window horizontally" })

-- Resize the current split's width. Bound to the physical +/- key (no shift
-- needed, same key), which most terminals report as <C-=>/<C--> regardless
-- of whether shift is held -- if yours reports <C-+> as a distinct key
-- (Kitty/Ghostty/WezTerm with the Kitty keyboard protocol on), that's mapped
-- too so it works either way.
map("n", "<C-=>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<C-+>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<C-->", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- LeetCode (plugin already ships via extras.lua, just wasn't bound to keys).
--
-- leetcode.nvim refuses to start ("Failed to initialize: `neovim` contains
-- listed buffers") unless there are zero listed buffers open -- that's the
-- plugin's own documented requirement, not a config issue. This helper
-- closes any unmodified listed buffers before launching so the keymap just
-- works from wherever you are; if something has unsaved changes it warns
-- instead of discarding your work.
local function leet(subcmd)
  return function()
    local dirty = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
        if vim.bo[buf].modified then
          table.insert(dirty, vim.api.nvim_buf_get_name(buf))
        else
          vim.api.nvim_buf_delete(buf, {})
        end
      end
    end
    if #dirty > 0 then
      vim.notify(
        "LeetCode needs no buffers open -- save/close first:\n" .. table.concat(dirty, "\n"),
        vim.log.levels.WARN
      )
      return
    end
    vim.cmd("Leet " .. subcmd)
  end
end

map("n", "<leader>ll", leet "", { desc = "LeetCode menu" })
map("n", "<leader>ld", leet "daily", { desc = "LeetCode daily" })
map("n", "<leader>lr", leet "random", { desc = "LeetCode random" })
map("n", "<leader>lt", "<cmd>Leet test<cr>", { desc = "LeetCode test" })
map("n", "<leader>ls", "<cmd>Leet submit<cr>", { desc = "LeetCode submit" })
map("n", "<leader>lo", leet "list", { desc = "LeetCode problem list" })
map("n", "<leader>li", "<cmd>Leet tabs<cr>", { desc = "LeetCode switch tabs" })

-- Copilot: nvchad's ai.lua only wires up the chat commands (aa/ae). These
-- lazy-load copilot.lua on first use via its `cmd = "Copilot"` spec, same as
-- lvim -- <leader>at only toggles the ghost-text auto-trigger, not the whole
-- client, that's what <leader>an/<leader>ad are for.
map("n", "<leader>an", "<cmd>Copilot enable<cr>", { desc = "Enable Copilot" })
map("n", "<leader>ad", "<cmd>Copilot disable<cr>", { desc = "Disable Copilot" })
map("n", "<leader>as", "<cmd>Copilot status<cr>", { desc = "Copilot status" })
map("n", "<leader>at", "<cmd>Copilot suggestion toggle_auto_trigger<cr>", { desc = "Toggle Copilot suggestions" })

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

    -- Workspace folders
    map(
      "n",
      "<leader>wa",
      vim.lsp.buf.add_workspace_folder,
      vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
    )
    map("n", "<leader>wl", function()
      -- No builtin telescope picker for this -- list_workspace_folders() is
      -- just a plain string list, so a minimal pickers/finders/sorter picker
      -- is all it needs.
      require("telescope.pickers")
        .new({}, {
          prompt_title = "LSP Workspace Folders",
          finder = require("telescope.finders").new_table {
            results = vim.lsp.buf.list_workspace_folders(),
          },
          sorter = require("telescope.config").values.generic_sorter {},
        })
        :find()
    end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
  end,
})
