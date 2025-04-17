-- Used as an in-memory cache that keeps track
-- of whatever paths where detected while using
-- Neovim.
local cache = {}

-- Sort by length so more specific cache
-- directories hit faster.
cache.sort = function()
  local keys = {}

  for key in pairs(cache) do
    if key ~= "sort" and key ~= "check" then
      table.insert(keys, key)
    end
  end

  table.sort(keys, function(a, b) return #a > #b end)

  return keys
end

-- Try to get a cache hit. Returns nil if no hit.
cache.check = function(file_name)
  local sorted_keys = cache.sort()

  for _, key in ipairs(sorted_keys) do
    if string.find(file_name, key, 1, true) then
      return cache[key]
    end
  end

  return nil
end

-- This will attempt to detect the existence of
-- the "tailwindcss" package, itself, or any
-- dependencies that follow the naming convension
-- below:
-- + @foo/tailwindcss
-- + @foo/tailwind
-- + @foo/tw
local valid_packages = {
  "tailwindcss",
  "@[^/]+/tailwindcss",
  "@[^/]+/tailwind",
  "@[^/]+/tw"
}

return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "neovim/nvim-lspconfig",
  },
  opts = {
    server = {
      -- Detects the paths, adds them to tailwind_tools_cache, and
      -- loads them from tailwind_tools_cache, when necessary.
      root_dir = function(file_name)
        local hit = cache.check(file_name)

        -- Early return, zero I/O, fast cache hit
        -- return when the file matches a base path
        -- within the cache.
        if hit ~= nil then
          return hit
        end

        local idx = string.find(file_name, "/[^/]+$")
        local dir = string.sub(file_name, 1, idx - 1)
        local package_json = dir .. "/package.json"

        -- By default, the LSP is not running for
        -- that entry. We denote this be defaulting
        -- it to nil.
        local root_dir = nil

        while true do
          if dir == "/" or dir == "." or dir == "" or dir == nil then
            break
          end

          if vim.fn.filereadable(package_json) == 1 then
            local file = io.open(package_json, "r")

            if file then
              local content = file:read("*a")
              file:close()

              for _, pkg in ipairs(valid_packages) do
                if content:find(pkg) then
                  root_dir = vim.loop.cwd()

                  if cache[dir] == nil then
                    cache[dir] = root_dir
                  end

                  break
                end
              end

              break
            else
              break
            end
          else
            idx = string.find(dir, "/[^/]+$")
            dir = string.sub(dir, 1, idx - 1)
            package_json = dir .. "/package.json"
          end
        end

        if root_dir == nil then
          local lspconfig = require("lspconfig")

          -- Update the tailwind_tools_cache.
          root_dir = lspconfig.util.root_pattern(
            lspconfig.util.insert_package_json({
              "tailwind.config.{js,cjs,mjs,ts}",
              "assets/tailwind.config.{js,cjs,mjs,ts}",
              "theme/static_src/tailwind.config.{js,cjs,mjs,ts}",
              "app/assets/stylesheets/application.tailwind.css",
              "app/assets/tailwind/application.css",
            }, "tailwindcss", file_name)
          )(file_name)
        end

        return root_dir
      end,
      settings = {
        experimental = {
          classRegex = {
            { "[a-zA-Z]+`([^`]*)`", "([^`]*)" },
            { "cva\\(([^)]*)\\)",   "[\"'`]([^\"'`]*).*?[\"'`]" },
            { "cx\\(([^)]*)\\)",    "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            ": `([^`]*)",           -- : `...`
            "= `([^`]*)",           -- = `...`
            "tw`([^`]*)",           -- tw`...`
            "\\$`([^`]*)",          -- $`...`
            "classes`([^`]*)",      -- classes`...`
            'tw="([^"]*)',          -- <div tw="..." />
            "tw='([^']*)",          -- <div tw='...' />
            'tw={"([^"}]*)',        -- <div tw={"..."} />
            "tw={'([^'}]*)",        -- <div tw={'...'} />
            "tw={`([^`}]*)",        -- <div tw={`...`} />
            'className="([^"]*)',   -- <div className="..." />
            "className='([^']*)",   -- <div className='...' />
            'className={"([^"}]*)', -- <div className={"..."} />
            "className={'([^'}]*)", -- <div className={'...'} />
            "className={`([^`}]*)", -- <div className={`...`} />
          },
        },
      }
    }
  }
}
