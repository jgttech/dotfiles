return function()
  local schema = require("schemastore")
  local json = schema.json.schemas()
  local yaml = schema.yaml.schemas()

  return {
    gopls = {},
    ols = {},
    zls = {},
    pyright = {},
    rust_analyzer = {},
    ts_ls = {},
    bashls = {},
    biome = {},
    cssls = {},
    dockerls = {},
    postgres_lsp = {
      cmd = { "postgrestools", "lsp-proxy" },
      settings = {
        filetypes = { "sql", "psql" },
        root_markers = { "postgrestools.jsonc" },
      },
    },
    docker_compose_language_service = {},
    prismals = {},
    markdown_oxide = {},
    prettierd = {},
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
        },
      },
    },
    -- tailwindcss = {
    --   filetypes = {
    --     "typescript",
    --     "typescriptreact",
    --     "javascript",
    --     "javascriptreact",
    --     "templ",
    --     "css",
    --     "html",
    --   },
    --   settings = {
    --     tailwindCSS = {
    --       experimental = {
    --         classRegex = {
    --           { "[a-zA-Z]+`([^`]*)`", "([^`]*)" },
    --           { "cva\\(([^)]*)\\)",   "[\"'`]([^\"'`]*).*?[\"'`]" },
    --           { "cx\\(([^)]*)\\)",    "(?:'|\"|`)([^']*)(?:'|\"|`)" },
    --           ": `([^`]*)",           -- : `...`
    --           "= `([^`]*)",           -- = `...`
    --           "tw`([^`]*)",           -- tw`...`
    --           "\\$`([^`]*)",          -- $`...`
    --           "classes`([^`]*)",      -- classes`...`
    --           'tw="([^"]*)',          -- <div tw="..." />
    --           "tw='([^']*)",          -- <div tw='...' />
    --           'tw={"([^"}]*)',        -- <div tw={"..."} />
    --           "tw={'([^'}]*)",        -- <div tw={'...'} />
    --           "tw={`([^`}]*)",        -- <div tw={`...`} />
    --           'className="([^"]*)',   -- <div className="..." />
    --           "className='([^']*)",   -- <div className='...' />
    --           'className={"([^"}]*)', -- <div className={"..."} />
    --           "className={'([^'}]*)", -- <div className={'...'} />
    --           "className={`([^`}]*)", -- <div className={`...`} />
    --         },
    --       },
    --     },
    --   },
    -- },
  }
end
