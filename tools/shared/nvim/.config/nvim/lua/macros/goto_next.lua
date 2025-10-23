local function goto_next()
  vim.diagnostic.jump({ count = 1, float = true })
end

return goto_next
