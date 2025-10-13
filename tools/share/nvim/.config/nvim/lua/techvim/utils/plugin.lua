local M = {}

-- TODO: Should be read from environment
local dotfiles_home = "~/.dotfiles"

M.LOCAL_NVIM_HOME = dotfiles_home .. "/packages/nvim/.config/nvim"
M.LOCAL_NVIM_PLUGINS = M.LOCAL_NVIM_HOME .. "/lua/techvim/local"

M.dir = function(name)
  return M.LOCAL_NVIM_PLUGINS .. "/" .. name
end

return M
