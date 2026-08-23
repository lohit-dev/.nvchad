return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local jdtls = require "jdtls"
      local jdtls_setup = require "jdtls.setup"
      local uv = vim.uv
      local mason_dir = vim.fn.stdpath "data" .. "/mason"
      local jdtls_dir = mason_dir .. "/packages/jdtls"
      local format_group = vim.api.nvim_create_augroup("JdtlsFormat", { clear = true })
      local attach_group = vim.api.nvim_create_augroup("JdtlsAttach", { clear = true })

      local platform_config = ({
        Darwin = "config_mac",
        Linux = "config_linux",
        Windows_NT = "config_win",
      })[uv.os_uname().sysname]

      local function bundles()
        local result = {}
        local debug_bundle =
          vim.fn.glob(mason_dir .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin.jar")

        if debug_bundle ~= "" then
          table.insert(result, debug_bundle)
        end

        return result
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = attach_group,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client or client.name ~= "jdtls" then
            return
          end

          vim.api.nvim_clear_autocmds { group = format_group, buffer = args.buf }
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_group,
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format {
                bufnr = args.buf,
                async = false,
                filter = function(format_client)
                  return format_client.name == "jdtls"
                end,
              }
            end,
          })

          pcall(jdtls.setup_dap, { hotcodereplace = "auto" })
        end,
      })

      local function start_jdtls(bufnr)
        local filename = vim.api.nvim_buf_get_name(bufnr)
        if filename == "" then
          return
        end

        local launcher = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")
        if launcher == "" or not platform_config or not uv.fs_stat(jdtls_dir) then
          vim.notify(
            "JDTLS is not installed. Run :MasonInstall jdtls java-debug-adapter java-test",
            vim.log.levels.ERROR
          )
          return
        end

        -- For standalone learning files, use their directory as the project root.
        local root_dir = jdtls_setup.find_root {
          ".git",
          ".project",
          "mvnw",
          "gradlew",
          "pom.xml",
          "build.gradle",
          "build.gradle.kts",
        } or vim.fs.dirname(filename)
        local project_name = vim.fn.fnamemodify(root_dir, ":t") .. "-" .. vim.fn.sha256(root_dir):sub(1, 8)
        local workspace_dir = vim.fn.stdpath "data" .. "/java/workspaces/" .. project_name
        vim.fn.mkdir(workspace_dir, "p")

        local extended_capabilities = jdtls.extendedClientCapabilities
        extended_capabilities.resolveAdditionalTextEditsSupport = true

        jdtls.start_or_attach {
          cmd = {
            "/opt/homebrew/opt/openjdk@21/bin/java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.level=WARN",
            "-javaagent:" .. jdtls_dir .. "/lombok.jar",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-jar",
            launcher,
            "-configuration",
            jdtls_dir .. "/" .. platform_config,
            "-data",
            workspace_dir,
          },
          root_dir = root_dir,
          capabilities = require("nvchad.configs.lspconfig").capabilities,
          flags = { allow_incremental_sync = true },
          init_options = {
            bundles = bundles(),
            extendedClientCapabilities = extended_capabilities,
          },
          settings = {
            java = {
              eclipse = { downloadSources = true },
              maven = { downloadSources = true },
              implementationsCodeLens = { enabled = true },
              referencesCodeLens = { enabled = true },
              signatureHelp = { enabled = true },
              configuration = { updateBuildConfiguration = "interactive" },
              format = { enabled = true },
              completion = {
                favoriteStaticMembers = {
                  "org.hamcrest.MatcherAssert.assertThat",
                  "org.hamcrest.Matchers.*",
                  "org.hamcrest.CoreMatchers.*",
                  "org.junit.jupiter.api.Assertions.*",
                  "java.util.Objects.requireNonNull",
                  "java.util.Objects.requireNonNullElse",
                  "org.mockito.Mockito.*",
                },
                importOrder = { "java", "javax", "com", "org" },
              },
              sources = {
                organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 },
              },
              codeGeneration = {
                toString = { template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}" },
                useBlocks = true,
              },
            },
          },
        }
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("JdtlsStart", { clear = true }),
        pattern = "java",
        callback = function(args)
          start_jdtls(args.buf)
        end,
      })

      if vim.bo.filetype == "java" then
        start_jdtls(vim.api.nvim_get_current_buf())
      end
    end,
  },
}
