return {
  'rebelot/kanagawa.nvim',
  config = function()
    require('kanagawa').setup {
      transparent = false,
      theme = 'wave',
    }

    -- Load the colorscheme here
    vim.cmd.colorscheme 'kanagawa'
  end,
}
