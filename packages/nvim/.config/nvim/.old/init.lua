local import = require 'utils.autoload'()
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

-- Loads the initial config for Neovim
require 'config.settings'
require 'config.keymap'
require 'config.autocmd'

-- Configure Lazy
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

-- All Lazy to path
vim.opt.rtp:prepend(lazypath)

-- Load Lazy plugins
require('lazy').setup(import 'plugins')
