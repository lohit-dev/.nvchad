require "nvchad.autocmds"
require "terminal_theme_sync"

if vim.fn.exists ":MasonInstallAll" == 0 then
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd "MasonInstall lua-language-server html-lsp css-lsp typescript-language-server gopls jdtls java-debug-adapter java-test pyright prettier stylua taplo dockerfile-language-server docker-compose-language-service yaml-language-server"
  end, { desc = "Install all language tools used by this configuration" })
end

if vim.fn.exists ":TSInstallAll" == 0 then
  vim.api.nvim_create_user_command("TSInstallAll", function()
    vim.cmd [[TSInstall vim lua vimdoc html css javascript typescript tsx json go rust java python swift toml dockerfile yaml]]
  end, { desc = "Install all Treesitter parsers used by this configuration" })
end
