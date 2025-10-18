return function()
  return {
    javascript = { "biome", "biome-organize-imports", "prettierd" },
    javascriptreact = { "biome", "biome-organize-imports", "prettierd" },
    typescript = { "biome", "biome-organize-imports", "prettierd" },
    typescriptreact = { "biome", "biome-organize-imports", "prettierd" },
    css = { "biome", "biome-organize-imports", "prettierd" },
    html = { "biome", "biome-organize-imports", "prettierd" },
    json = { "biome", "biome-organize-imports", "prettierd" },
    yaml = { "biome", "biome-organize-imports", "prettierd" },
    markdown = { "biome", "biome-organize-imports", "prettierd" },

    -- TBD
    -- javascript = { "biome", "prettierd", stop_after_first = true },
    -- typescript = { "biome", "prettierd", stop_after_first = true },
    -- javascriptreact = { "biome", "prettierd", stop_after_first = true },
    -- typescriptreact = { "biome", "prettierd", stop_after_first = true },
    -- go = { "gofmt", "goimports" },
    -- css = { "biome", "prettierd", stop_after_first = true },
    -- html = { "biome", "prettierd", stop_after_first = true },
    -- json = { "biome", "prettierd", stop_after_first = true },
    -- yaml = { "biome", "prettierd", stop_after_first = true },
    -- markdown = { "biome", "prettierd", stop_after_first = true },

    go = { "goimports", "gofmt" },
    python = { "isort", "black" },
    tailwindcss = { "rustywind" },
    ols = {},
    zls = {},
  }
end
