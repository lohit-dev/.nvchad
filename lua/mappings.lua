require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>")

-- projects
local function open_projects()
  require("telescope").extensions.projects.projects {}
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
  vim.notify("Inlay hints " .. (enabled and "enabled" or "disabled"), vim.log.levels.INFO)
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
