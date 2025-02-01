-- stylua: ignore
local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
  purple = '#938aa9',
  light_purple = '#C9C4D4',
  orange = "#ff9e64"
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.purple },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },
  command = {
    a = { fg = colors.black, bg = colors.light_purple },
  },

  insert = { a = { fg = colors.black, bg = colors.orange } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local lualine = require 'lualine'
    local lazy_status = require 'lazy.status'

    lualine.setup {
      options = {
        theme = bubbles_theme,
        -- component_separators = "|",
        -- section_separators = { left = "", right = "" },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          -- { "mode", separator = { left = "", right = "" }, right_padding = 2 },
          { 'mode', separator = { left = '', right = '' }, right_padding = 2 },
        },
        lualine_b = { 'filename', 'branch' },
        lualine_c = { { 'fileformat', color = { fg = colors.white } } },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = colors.orange },
          },
        },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          -- { "location", separator = { right = "", left = "" }, left_padding = 2 },
          { 'location', separator = { right = '', left = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      tabline = {},
      extensions = {},
    }
  end,
}
