-- Keep supported terminal colors matched to the active Base46 theme.
-- Alacritty, Kitty, and Ghostty support OSC 4, 10, 11, and 12 color updates.

local group = vim.api.nvim_create_augroup("TerminalThemeSync", { clear = true })

local function send_osc(sequence)
  local is_alacritty = vim.env.ALACRITTY_LOG or vim.env.TERM_PROGRAM == "Alacritty"
  local is_kitty = vim.env.KITTY_WINDOW_ID ~= nil or vim.env.TERM_PROGRAM == "kitty"
  local is_ghostty = vim.env.TERM_PROGRAM == "ghostty"
  if not is_alacritty and not is_kitty and not is_ghostty then
    return
  end

  local escape = "\27]" .. sequence .. "\7"
  if vim.env.TMUX then
    escape = "\27Ptmux;" .. escape:gsub("\27", "\27\27") .. "\27\\"
  end
  io.stdout:write(escape)
  io.stdout:flush()
end

local function sync_tmux(base16, base30)
  if not vim.env.TMUX or vim.fn.executable("tmux") ~= 1 then
    return
  end

  local background = base16.base00
  local foreground = base16.base05
  local palette = {
    ["status-style"] = "bg=" .. background .. ",fg=" .. foreground,
    ["window-status-style"] = "bg=" .. background .. ",fg=" .. base16.base04,
    ["window-status-current-style"] = "bg=" .. background .. ",fg=" .. base16.base0D .. ",bold",
    ["pane-border-style"] = "fg=" .. base16.base03,
    ["pane-active-border-style"] = "fg=" .. base16.base0D,
    ["message-style"] = "bg=" .. base16.base02 .. ",fg=" .. foreground,
    ["message-command-style"] = "bg=" .. base16.base02 .. ",fg=" .. foreground,
    ["mode-style"] = "bg=" .. base16.base0D .. ",fg=" .. background,
    ["clock-mode-colour"] = base16.base0D,
    ["copy-mode-match-style"] = "bg=" .. base16.base0A .. ",fg=" .. background,
    ["copy-mode-current-match-style"] = "bg=" .. base16.base0E .. ",fg=" .. background,
    ["display-panes-active-colour"] = base16.base0B,
    ["display-panes-colour"] = base16.base04,
    ["@thm_bg"] = base16.base00,
    ["@thm_fg"] = base16.base05,
    ["@thm_crust"] = base16.base00,
    ["@thm_mantle"] = base16.base00,
    ["@thm_base"] = base16.base00,
    ["@thm_surface_0"] = base16.base01,
    ["@thm_surface_1"] = base16.base02,
    ["@thm_surface_2"] = base16.base03,
    ["@thm_overlay_0"] = base16.base04,
    ["@thm_overlay_1"] = base16.base04,
    ["@thm_overlay_2"] = base16.base05,
    ["@thm_subtext_0"] = base16.base04,
    ["@thm_subtext_1"] = base16.base05,
    ["@thm_text"] = base16.base07,
    ["@thm_rosewater"] = base16.base07,
    ["@thm_flamingo"] = base16.base06,
    ["@thm_pink"] = base16.base0E,
    ["@thm_maroon"] = base16.base08,
    ["@thm_red"] = base16.base08,
    ["@thm_peach"] = base16.base09,
    ["@thm_yellow"] = base16.base0A,
    ["@thm_green"] = base16.base0B,
    ["@thm_teal"] = base16.base0C,
    ["@thm_sky"] = base16.base0C,
    ["@thm_sapphire"] = base16.base0D,
    ["@thm_blue"] = base16.base0D,
    ["@thm_lavender"] = base16.base0D,
    ["@thm_mauve"] = base16.base0E,
    ["@thm_surface_0_alt"] = base30.black2,
  }

  for option, value in pairs(palette) do
    vim.fn.system({ "tmux", "set-option", "-g", option, value })
  end
end

local function write_kitty_theme(base16)
  local background = base16.base00
  local foreground = base16.base05
  local colors = {
    [0] = background,
    [1] = base16.base08,
    [2] = base16.base0B,
    [3] = base16.base0A,
    [4] = base16.base0D,
    [5] = base16.base0E,
    [6] = base16.base0C,
    [7] = foreground,
    [8] = base16.base03,
    [9] = base16.base08,
    [10] = base16.base0B,
    [11] = base16.base0A,
    [12] = base16.base0D,
    [13] = base16.base0E,
    [14] = base16.base0C,
    [15] = base16.base07,
  }

  local lines = {
    "# Generated from the active NvChad Base46 theme.",
    "foreground " .. foreground,
    "background " .. background,
    "selection_foreground " .. foreground,
    "selection_background " .. base16.base02,
    "cursor " .. foreground,
    "cursor_text_color " .. background,
    "",
  }
  for index = 0, 15 do
    lines[#lines + 1] = string.format("color%d %s", index, colors[index])
  end
  vim.list_extend(lines, {
    "",
    "tab_bar_background " .. background,
    "tab_bar_margin_color " .. background,
    "active_tab_foreground " .. background,
    "active_tab_background " .. base16.base0D,
    "inactive_tab_foreground " .. base16.base04,
    "inactive_tab_background " .. base16.base01,
    "active_border_color " .. base16.base0D,
    "inactive_border_color " .. base16.base02,
    "",
  })

  local path = vim.fn.expand("~/.config/kitty/theme.conf")
  local contents = table.concat(lines, "\n")
  local existing = io.open(path, "r")
  if existing then
    local current = existing:read("*a")
    existing:close()
    if current == contents then
      return
    end
  end

  local temporary = path .. ".tmp"
  local file = io.open(temporary, "w")
  if not file then
    return
  end
  file:write(contents)
  file:close()
  os.rename(temporary, path)
end

local function sync_theme()
  local ok, palette = pcall(function()
    local base46 = require("base46")
    return {
      base_16 = base46.get_theme_tb("base_16"),
      base_30 = base46.get_theme_tb("base_30"),
    }
  end)
  if not ok or not palette then
    return
  end

  local c = palette.base_16
  write_kitty_theme(c)
  sync_tmux(c, palette.base_30)
  local background = c.base00 or palette.base_30.black
  local foreground = c.base05 or palette.base_30.white
  local colors = {
    [0] = background,
    [1] = c.base08,
    [2] = c.base0B,
    [3] = c.base0A,
    [4] = c.base0D,
    [5] = c.base0E,
    [6] = c.base0C,
    [7] = foreground,
    [8] = c.base03,
    [9] = c.base08,
    [10] = c.base0B,
    [11] = c.base0A,
    [12] = c.base0D,
    [13] = c.base0E,
    [14] = c.base0C,
    [15] = c.base07,
  }

  send_osc("10;" .. foreground)
  send_osc("11;" .. background)
  send_osc("12;" .. foreground)

  for index = 0, 15 do
    local color = colors[index]
    if type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
      send_osc("4;" .. index .. ";" .. color)
    end
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    vim.schedule(sync_theme)
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "NvThemeReload",
  callback = sync_theme,
})
