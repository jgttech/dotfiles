local M = {}

M.next = function()
  vim.diagnostic.jump({ count = 1, float = true })
end

M.prev = function()
  vim.diagnostic.jump({ count = -1, float = true })
end

return M
