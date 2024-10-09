-- [IMPORTANT]
-- Uses the Mason language server options.
-- https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#available-lsp-servers
--
-- Languages that the LSP should support. This was put
-- here because I do not want to have to mess with the
-- internal workings of things to add support for more languages
-- in the LSP later on, as this changes and grows.
return {
  treesitter = {
    'bash',
    'c',
    'odin',
    'comment',
    'css',
    'elixir',
    'gitattributes',
    'gitignore',
    'gitcommit',
    'go',
    'html',
    'javascript',
    'typescript',
    'markdown',
    'json5',
    'jsonc',
    'lua',
    'python',
    'prisma',
    'rust',
    'sql',
    'toml',
    'tsx',
    'yaml',
    'vim',
    'vimdoc',
    'query',
    'zig',
  },
  -- Feeds the confirm Neovim plugin "formatters_by_ft".
  conform = {
    javascript = { 'prettier', 'biome' },
    typescript = { 'prettier', 'biome' },
    javascriptreact = { 'prettier', 'biome' },
    typescriptreact = { 'prettier', 'biome' },
    css = { 'prettier', 'biome' },
    html = { 'prettier', 'biome' },
    json = { 'prettier', 'biome' },
    yaml = { 'prettier', 'biome' },
    markdown = { 'prettier', 'biome' },
    python = { 'isort', 'black' },
    tailwindcss = { 'rustywind' },
    go = { 'gofmt', 'goimports' },
    ols = {},
  },
  -- Feeds all the mason config.
  mason = {
    gopls = {},
    ols = {},
    pyright = {},
    rust_analyzer = {},
    ts_ls = {},
    bashls = {},
    biome = {},
    cssls = {},
    dockerls = {},
    docker_compose_language_service = {},
    prismals = {},
    markdown_oxide = {},
    eslint_d = {
      settings = {
        packageManager = 'yarn',
      },
      on_attach = function(_, bufnr)
        vim.api.nvim_create_autocmd('BufReadPre', {
          buffer = bufnr,
          command = 'EslintFixAll',
        })
      end,
    },
    html = {},
    jsonls = {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    },
    yamlls = {
      settings = {
        yaml = {
          schemaStore = {
            enable = false,
            url = '',
          },
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    },
    tailwindcss = {
      filetypes = {
        'typescript',
        'typescriptreact',
        'javascript',
        'javascriptreact',
        'templ',
        'css',
        'html',
      },
      settings = {
        tailwindCSS = {
          experimental = {
            classRegex = {
              { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
              { 'cx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              ': `([^`]*)', -- = `...`
              '= `([^`]*)', -- = `...`
              'tw`([^`]*)', -- tw`...`
              '\\$`([^`]*)', -- $`...`
              'classes`([^`]*)', -- classes`...`
              'tw="([^"]*)', -- <div tw="..." />
              "tw='([^']*)", -- <div tw='...' />
              'tw={"([^"}]*)', -- <div tw={"..."} />
              "tw={'([^'}]*)", -- <div tw={'...'} />
              'tw={`([^`}]*)', -- <div tw={`...`} />
              'className="([^"]*)', -- <div className="..." />
              "className='([^']*)", -- <div className='...' />
              'className={"([^"}]*)', -- <div className={"..."} />
              "className={'([^'}]*)", -- <div className={'...'} />
              'className={`([^`}]*)', -- <div className={`...`} />
            },
          },
        },
      },
    },
  },
}
