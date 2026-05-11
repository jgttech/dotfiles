local function goto_prev()
  vim.diagnostic.jump({ count = -1, float = true })
end

return goto_prev
