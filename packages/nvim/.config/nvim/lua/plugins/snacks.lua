return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = false }, -- Disabled: Using alpha-nvim instead
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = {
      enabled = true,
      -- =============================================================================
      -- DEPRECATION WARNING FILTER
      -- =============================================================================
      -- Filters out LSP deprecation warnings from Neovim 0.11 that appear in
      -- snacks notifications. These come from plugins not yet updated for 0.11.
      --
      -- TODO: Periodically test if this filter can be removed:
      --   1. Update plugins: :Lazy update
      --   2. Press 'gd' on a function definition
      --   3. If no notification appears, remove this filter
      -- =============================================================================
      filter = function(notif)
        if notif and notif.msg then
          local msg = tostring(notif.msg)

          -- TODO: Remove when plugins update for Neovim 0.11
          -- REASON: Plugins use deprecated vim.lsp.util functions
          -- AFFECTS: Telescope, nvim-navic, and other LSP plugins
          -- CHECK: Press 'gd' - if no notification, these can be removed

          if msg:match("position_encoding") then
            return false -- Suppress position_encoding parameter warnings
          end
          if msg:match("make_position_param") then
            return false -- Suppress make_position_param warnings
          end
          if msg:match("vim%.lsp%.util") then
            return false -- Suppress any vim.lsp.util deprecation warnings
          end
        end
        return true
      end,
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
}
