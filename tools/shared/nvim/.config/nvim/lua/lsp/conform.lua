return {
  -- JavaScript/TypeScript: Try biome first (fastest), fall back to prettierd
  javascript = { "biome", "prettierd", stop_after_first = true },
  javascriptreact = { "biome", "prettierd", stop_after_first = true },
  typescript = { "biome", "prettierd", stop_after_first = true },
  typescriptreact = { "biome", "prettierd", stop_after_first = true },

  -- Web formats: Try biome first, fall back to prettierd
  css = { "biome", "prettierd", stop_after_first = true },
  html = { "biome", "prettierd", stop_after_first = true },
  json = { "biome", "prettierd", stop_after_first = true },
  yaml = { "prettierd" },     -- Biome doesn't support YAML well
  markdown = { "prettierd" }, -- Prettier is better for markdown

  -- Other languages
  go = { "goimports", "gofmt" },
  python = { "isort", "black" },
  tailwindcss = { "rustywind" },
  ols = {},
  zls = {},
}
