local tbl = require("utils.table")
local config = require("lsp.conform")

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fb",
      function()
        require("conform").format({ async = true, lsp_format = "never" })
      end,
      mode = "",
      desc = "[F]ormat buffer",
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      local lsp_format_opt = "never"
      return {
        timeout_ms = 500,
        lsp_format = lsp_format_opt,
      }
    end,
    formatters_by_ft = tbl.merge(config, {
      lua = { "stylua" },
    }),
  },
}
