local function close_buffer()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  for _, buf in ipairs(buffers) do
    if buf.bufnr ~= current then
      vim.api.nvim_buf_delete(buf.bufnr, { force = false })
    end
  end
end

return close_buffer
