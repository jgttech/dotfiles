return {
  'numToStr/Comment.nvim',
  dependencies = {
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  opts = {},
  config = function()
    local comment = require 'Comment'
    local ts_context_comment = require 'ts_context_commentstring'
    local comment_nvim = require 'ts_context_commentstring.integrations.comment_nvim'

    ts_context_comment.setup {
      enable = true,
      enable_autocmd = false,
    }

    comment.setup {
      pre_hook = comment_nvim.create_pre_hook(),
    }
  end,
}
