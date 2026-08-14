return {
  -- Switched from nvim-jdtls + spring-boot.nvim to nvim-java: it manages
  -- its own JDK, jdtls, java-test, java-debug-adapter, and lombok installs
  -- through its own Mason registry (registries below), and includes Spring
  -- Boot support (completion/validation for annotations and
  -- application.properties/yml) out of the box -- one plugin instead of
  -- three, with no ftplugin/java.lua of our own to maintain. The two
  -- approaches are also mutually exclusive: nvim-java replaces nvim-jdtls
  -- entirely rather than building on it.
  --
  -- One trade-off worth knowing: nvim-java pulls in mfussenegger/nvim-dap
  -- and nvim-java-dap as hard dependencies (there's no supported way to
  -- install it without them), so DAP support comes along whether it gets
  -- used or not. It's inert unless something actually calls into it though
  -- -- running/testing here still goes through overseer (<leader>or /
  -- overseer/template/user/*.lua), not nvim-java's own DAP-backed runner.
  --
  -- Loaded on `ft = "java"` like the rest of this config's language
  -- plugins (go.lua, rust.lua); its `config` function runs exactly once,
  -- the first time a .java buffer opens, and both nvim-java itself and
  -- jdtls need to be initialized in that same call, in this order --
  -- nvim-java's setup() has to run before lspconfig's jdtls.setup() so it
  -- can register its own jdtls command/bundles first.
  {
    "nvim-java/nvim-java",
    ft = "java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-refactor",
      "nvim-java/nvim-java-core",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- Explicit root_markers, `.git` excluded on purpose: nvim-java's
      -- default markers include `.git`, and jdtls walks *up* from the
      -- buffer looking for the first match. If a Java file ever gets
      -- opened somewhere under a git-managed home directory (dotfiles
      -- repos, a scratch file outside any real project), `.git` at $HOME
      -- would win before it reaches an actual pom.xml/build.gradle,
      -- attaching jdtls with the wrong project root -- which looks
      -- exactly like "Java doesn't work" (no completions/diagnostics,
      -- silent). Maven/Gradle markers only means jdtls only attaches
      -- inside real Java projects.
      require("java").setup {
        root_markers = {
          "pom.xml",
          "build.gradle",
          "build.gradle.kts",
          "settings.gradle",
          "settings.gradle.kts",
          "mvnw",
          "gradlew",
        },
      }
      require("lspconfig").jdtls.setup {
        capabilities = require("nvchad.configs.lspconfig").capabilities,
      }
    end,
  },
}
