require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

-- projects
local function open_projects()
  -- Ensure telescope is loaded, then ensure the extension is registered,
  -- then open the picker. This is safe to call multiple times.
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("telescope.nvim is not available", vim.log.levels.ERROR)
    return
  end
  if not telescope.extensions.projects then
    telescope.load_extension "projects"
  end
  telescope.extensions.projects.projects {}
end
map("n", "'", open_projects, { desc = "Find projects" })
map("n", "<leader>p", open_projects, { desc = "Find projects" })

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

-- lsp
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP code action" })

-- override NvChad's <leader>th (themes) → inlay hints toggle
-- State is persisted to disk so it survives restarts.
local hints_state_file = vim.fn.stdpath "state" .. "/inlay_hints"

local function inlay_hints_load()
  local f = io.open(hints_state_file, "r")
  if f then
    local val = f:read "*l"
    f:close()
    return val == "true"
  end
  return false -- off by default
end

local function inlay_hints_save(enabled)
  vim.fn.mkdir(vim.fn.fnamemodify(hints_state_file, ":h"), "p")
  local f = io.open(hints_state_file, "w")
  if f then
    f:write(tostring(enabled))
    f:close()
  end
end

-- Apply saved state on every LSP attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("inlay-hints-persist", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(inlay_hints_load(), { bufnr = args.buf })
    end
  end,
})

map("n", "<leader>th", function()
  local enabled = not vim.lsp.inlay_hint.is_enabled()
  vim.lsp.inlay_hint.enable(enabled)
  inlay_hints_save(enabled)
end, { desc = "Toggle inlay hints" })

-- NvChad theme picker (was <leader>th, moved here)
map("n", "<leader>ft", function()
  require("nvchad.themes").open()
end, { desc = "Pick NvChad theme" })

-- windows
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
map("n", "<leader>wh", "<cmd>split<cr>", { desc = "Split window horizontally" })
map("n", "<C-=>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<C-+>", "<cmd>vertical resize +5<cr>", { desc = "Increase window width" })
map("n", "<C-->", "<cmd>vertical resize -5<cr>", { desc = "Decrease window width" })

-- ── Overseer ──────────────────────────────────────────────────────────────────

require("overseer").setup {
  task_list = {
    direction = "bottom",
    min_height = 20,
    max_height = 20,
    default_detail = 1,
  },
}

map("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })

-- Close the vsplit from the last run before opening a new one, so repeat
-- runs replace the output in place instead of stacking vsplits sideways
-- forever. task:open_output("vertical") always does a plain vim.cmd.vsplit()
-- with no "reuse an existing window" option, so we track the window ourselves.
local last_output_win = nil

local function open_task_in_vsplit(task)
  if last_output_win and vim.api.nvim_win_is_valid(last_output_win) then
    vim.api.nvim_win_close(last_output_win, true)
  end
  require("overseer").run_action(task, "open vsplit")
  last_output_win = vim.api.nvim_get_current_win()
end

-- run_template (what :OverseerRun uses under the hood) is deprecated in favor
-- of run_task as of overseer 2026; same behavior, opts={} still triggers the
-- template picker. After you pick and it starts, force the "open vsplit"
-- action so you always see live output instead of just a pass/fail notify.
map("n", "<leader>or", function()
  require("overseer").run_task({}, function(task, err)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    if not task then
      return
    end
    open_task_in_vsplit(task)
  end)
end, { desc = "Run task (vsplit output)" })

-- OverseerShell builds+starts the task itself with no completion callback,
-- so this bypasses the ":OverseerShell " command-line prefill and drives the
-- same new_task -> start -> "open vsplit" flow as <leader>or above, giving
-- custom one-off commands the same vsplit output instead of a silent
-- pass/fail notify.
map("n", "<leader>oc", function()
  vim.ui.input({ prompt = "Shell command: " }, function(cmd)
    if not cmd or cmd == "" then
      return
    end
    local task = require("overseer").new_task { cmd = cmd }
    task:start()
    open_task_in_vsplit(task)
  end)
end, { desc = "Run custom command (vsplit output)" })

-- Task output buffers are filetype "OverseerOutput" -- scope `q`-to-close to
-- just those, so it doesn't hijack macro recording anywhere else.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "OverseerOutput",
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true, desc = "Close task output" })
  end,
})

-- Terminal-mode escape: NvChad's own <C-x> escape got dropped above, but
-- :terminal buffers still show up here and there (overseer task output uses
-- a real terminal buffer under the hood -- see overseer.lua's output.use_terminal,
-- and any ad-hoc `:term`/`:vs term://...` split). Without a mapping there's no
-- way back to Normal mode: plain <Esc> is passed straight through to the
-- program running in the terminal, it isn't intercepted by Neovim.
-- <C-\><C-n> is the actual built-in escape sequence; this just binds it to
-- the muscle-memory key.
-- CAVEAT: <C-[> and a literal <Esc> keypress are the exact same byte (0x1B)
-- over a plain terminal connection, so this mapping also fires on plain Esc
-- unless your terminal emulator sends the Kitty keyboard protocol's extended
-- CSI-u encoding to disambiguate them (Kitty/Ghostty/WezTerm with that
-- protocol enabled do; most others don't). If you use a nested TUI program
-- inside the terminal (vim-in-vim, less, fzf, ...) that expects a real Esc,
-- this will exit the outer terminal buffer instead of reaching it -- use
-- <C-\><C-n> directly in that case.
map("t", "<C-[>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
