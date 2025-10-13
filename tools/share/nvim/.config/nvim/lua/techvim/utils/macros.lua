local M = {}

M.goto_next = function()
  vim.diagnostic.jump({ count = 1, float = true })
end

M.goto_prev = function()
  vim.diagnostic.jump({ count = -1, float = true })
end

M.oil_cwd = function()
  require("oil").open(vim.fn.getcwd())
end

return M
