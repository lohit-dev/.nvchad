return {
	{
		"olexsmir/gopher.nvim",
		ft = "go",
		build = function()
			-- Sync, not GoInstallDeps: the async version fires `go install` for
			-- gomodifytags/impl/gotests/iferr/json2go and returns immediately
			-- without waiting -- if nvim closed before those background installs
			-- finished, the binaries (json2go included) silently never landed,
			-- even though lazy.nvim reported the build as done. Sync blocks
			-- until each one actually finishes.
			vim.cmd.GoInstallDepsSync()
		end,
		opts = {},
		config = function(_, opts)
			require("gopher").setup(opts)

			-- `:GoInstallDeps` runs `go install` for gomodifytags/impl/gotests/
			-- iferr/json2go into `go env GOBIN` (or GOPATH/bin, default ~/go/bin).
			-- If nvim was started from a shell/session where that dir isn't on
			-- PATH (the ENOENT: json2go error), the binaries exist but gopher
			-- can't find them. Make sure it's there regardless of shell.
			local go_bin = vim.env.GOBIN
				or (vim.env.GOPATH and vim.env.GOPATH ~= "" and vim.env.GOPATH .. "/bin")
				or vim.fn.expand("~/go/bin")
			if vim.fn.isdirectory(go_bin) == 1 and not vim.env.PATH:find(go_bin, 1, true) then
				vim.env.PATH = go_bin .. ":" .. vim.env.PATH
			end
		end,
	},
}
