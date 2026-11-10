local M = {}

local state_file = vim.fn.stdpath "state" .. "/diagnostic_virtual_text"
local enabled = true

local function load_state()
  local file = io.open(state_file, "r")
  if not file then
    return
  end

  enabled = file:read "*l" ~= "false"
  file:close()
end

local function save_state()
  vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
  local file = io.open(state_file, "w")
  if file then
    file:write(tostring(enabled))
    file:close()
  end
end

load_state()

function M.apply()
  vim.diagnostic.config {
    virtual_text = enabled and { prefix = "" } or false,
  }
end

function M.toggle()
  enabled = not enabled
  save_state()
  M.apply()
  vim.notify("Diagnostic inline text " .. (enabled and "on" or "off"))
end

return M
