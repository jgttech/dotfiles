local schema = require("schemastore")
local json = schema.json.schemas()
local yaml = schema.yaml.schemas()

return {
  astro = {},
  gopls = {},
  ols = {},
  zls = {},
  pyright = {},
  rust_analyzer = {},
  ts_ls = {
    -- Wrap in function to avoid circular dependency with lspconfig
    root_dir = function(fname)
      return require("lspconfig").util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
    end,
    -- Enable taking file changes from disk
    init_options = {
      preferences = {
        -- This helps the LSP resolve path aliases more reliably
        importModuleSpecifierPreference = "non-relative",
      },
    },
    settings = {
      typescript = {
        -- Ensure path mappings from tsconfig are used
        preferences = {
          importModuleSpecifierPreference = "non-relative",
        },
      },
      javascript = {
        preferences = {
          importModuleSpecifierPreference = "non-relative",
        },
      },
    },
  },
  bashls = {},
  biome = {},
  cssls = {},
  tailwindcss = {
    -- Tailwind CSS Language Server
    -- Provides IntelliSense for Tailwind CSS classes
    filetypes = {
      "html",
      "css",
      "scss",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
      "astro",
      "templ",
    },
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            -- Support for class attributes
            { "class:\\s*?[\"'`]([^\"'`]*).*?[\"'`]", "[\"'`]([^\"'`]*).*?[\"'`]" },
            -- Support for className attributes
            { "className:\\s*?[\"'`]([^\"'`]*).*?[\"'`]", "[\"'`]([^\"'`]*).*?[\"'`]" },
            -- Support for clsx/classnames utilities
            { "(?:clsx|classnames|cn)\\(([^)]*)\\)", "(?:[\"'`]([^\"'`]*).*?[\"'`])" },
            -- Support for template literals
            { "[\"'`]([^\"'`]*)[\"'`]" },
          },
        },
        validate = true,
        lint = {
          cssConflict = "warning",
          invalidApply = "error",
          invalidScreen = "error",
          invalidVariant = "error",
          invalidConfigPath = "error",
          invalidTailwindDirective = "error",
          recommendedVariantOrder = "warning",
        },
      },
    },
  },
  dockerls = {},
  postgres_lsp = {
    cmd = { "postgres-language-server", "up", "--method", "stdio" },
    settings = {
      filetypes = { "sql", "psql" },
      root_markers = { ".pg_lsp.toml" },
    },
  },
  docker_compose_language_service = {},
  prismals = {},
  markdown_oxide = {},
  terraformls = {},
  eslint_d = {
    settings = {
      packageManager = "npm",
    },
    on_attach = function(_, bufnr)
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        command = "EslintFixAll",
      })
    end,
  },
  html = {},
  jsonls = {
    settings = {
      json = {
        schemas = json,
        validate = { enable = true },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          -- Disable schemaStore to avoid CloudFormation tag errors
          enable = false,
          url = "",
        },
        schemas = yaml,
        -- Keep validation enabled for syntax checking
        validate = true,
      },
    },
  },
  templ = {},
}
