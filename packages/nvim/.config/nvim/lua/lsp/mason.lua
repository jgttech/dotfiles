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
    -- Ensure ts_ls finds the project root by looking for these files
    root_dir = require("lspconfig").util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
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
  dockerls = {},
  postgres_lsp = {
    cmd = { "postgrestools", "", "lsp-proxy" },
    settings = {
      filetypes = { "sql", "psql" },
      root_markers = { "postgrestools.jsonc" },
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
      vim.api.nvim_create_autocmd("BufReadPre", {
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
          enable = false,
          url = "",
        },
        schemas = yaml,
        customTags = {
          "!fn",
          "!And",
          "!If",
          "!Not",
          "!Equals",
          "!Or",
          "!FindInMap sequence",
          "!Base64",
          "!Cidr",
          "!Ref",
          "!Ref Scalar",
          "!Sub",
          "!GetAtt",
          "!GetAZs",
          "!ImportValue",
          "!Select",
          "!Split",
          "!Join sequence",
        },
      },
    },
  },
  templ = {},
}
