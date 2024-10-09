return {
  'rebelot/kanagawa.nvim',
  config = function()
    require('kanagawa').setup {
      transparent = true,
      theme = 'wave',
    }

    -- Load the colorscheme here
    vim.cmd.colorscheme 'kanagawa'

    -- You can configure highlights by doing something like
    vim.cmd.hi 'Comment gui=none'
  end,
}
