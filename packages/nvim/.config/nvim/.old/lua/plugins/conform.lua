-- Autoformat
local merge = require 'utils.merge'

return {
  'stevearc/conform.nvim',
  config = function()
    local conform = require 'conform'

    conform.setup {
      notify_on_error = false,
      formatters_by_ft = merge(require('lsp').conform, {
        lua = { 'stylua' },
      }),
      default_format_opts = {
        lsp_format = 'fallback',
        quiet = true,
      },
      format_after_save = function(bufnr)
        -- Disable "format_after_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }

        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
    }

    vim.keymap.set('n', '<leader>fb', function()
      conform.format {
        lsp_fallback = true,
        async = true,
        timeout_ms = 500,
        quiet = true,
      }
    end, { desc = 'Format file or range (in visual mode)' })
  end,
}
