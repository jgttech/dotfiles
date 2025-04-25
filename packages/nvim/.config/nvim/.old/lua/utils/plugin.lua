local M = {}

M.LOCAL_NVIM_HOME = "~/.dotfiles/packages/nvim/.config/nvim"
M.LOCAL_NVIM_PLUGINS = M.LOCAL_NVIM_HOME .. "/lua/local"

M.dir = function(name)
  return M.LOCAL_NVIM_PLUGINS .. "/" .. name
end

return M
