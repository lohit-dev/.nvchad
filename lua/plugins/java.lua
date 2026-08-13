return {
	-- Deliberately nvim-jdtls, not nvim-java: nvim-java bundles its own JDK
	-- management, DAP wiring, and test runner UI on top of jdtls -- a much
	-- heavier layer than wanted here, and the two aren't compatible side by
	-- side anyway (nvim-java requires removing nvim-jdtls entirely). This
	-- config already covers what nvim-java's extra layer would have: Mason
	-- installs the JDK-backed jdtls binary itself (plugins/lsp.lua), and
	-- overseer's user templates cover run/test/spring-boot-run. nvim-jdtls
	-- is the "keep it simple, configure it yourself" option -- see
	-- ftplugin/java.lua for the actual start_or_attach setup, which is
	-- where all the real configuration lives (nvim-jdtls has no `opts`/
	-- `config` of its own -- it's driven entirely from ftplugin/java.lua,
	-- run fresh every time a Java buffer loads).
	{
		"mfussenegger/nvim-jdtls",
		ft = "java",
	},

	-- Spring Boot support: runs the actual Spring Boot language server
	-- (VMware's sts4, same one VS Code's Spring Boot extension uses) as a
	-- jdtls bundle, wired in from ftplugin/java.lua. Gives completion/
	-- validation for annotations (@Autowired, @Bean, @RequestMapping, ...)
	-- and application.properties/.yml keys -- none of which plain jdtls
	-- understands on its own. Its symbol-search commands (e.g. jumping to
	-- `@Component`-annotated beans) optionally use fzf-lua or telescope for
	-- the picker UI -- this config already has telescope (plugins/
	-- telescope.lua), so no extra fuzzy-finder dependency needed here.
	{
		"JavaHello/spring-boot.nvim",
		ft = { "java", "yaml", "jproperties" },
		dependencies = { "mfussenegger/nvim-jdtls" },
		opts = {},
	},
}
