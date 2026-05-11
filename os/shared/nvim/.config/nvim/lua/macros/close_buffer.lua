-- Close buffer but keep window layout
function close_buffer()
  local buf = vim.api.nvim_get_current_buf()
  local buf_count = #vim.fn.getbufinfo({ buflisted = 1 })

  if buf_count > 1 then
    vim.cmd('bprevious') -- Switch to previous buffer
  end

  vim.api.nvim_buf_delete(buf, { force = false })
end

return close_buffer
