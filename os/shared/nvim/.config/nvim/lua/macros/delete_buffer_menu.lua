-- Interactive buffer deletion menu
function delete_buffer_menu()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.fn.getbufinfo({ buflisted = 1 })

  local choices = {
    "Delete current buffer",
    "Delete all other buffers",
    "Delete buffers to right",
    "Delete buffers to left",
    "Search and delete single buffer",
    "Search and delete multiple buffers",
  }

  vim.ui.select(choices, {
    prompt = "Buffer deletion options:",
  }, function(choice, idx)
    if not idx then return end

    if idx == 1 then
      -- Delete current buffer
      if #buffers > 1 then
        vim.cmd('bprevious')
      end
      pcall(vim.api.nvim_buf_delete, current, { force = true })
    elseif idx == 2 then
      -- Delete all other buffers
      for _, buf in ipairs(buffers) do
        if buf.bufnr ~= current then
          pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = true })
        end
      end
    elseif idx == 3 then
      -- Delete all buffers to right
      for _, buf in ipairs(buffers) do
        if buf.bufnr > current then
          pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = true })
        end
      end
    elseif idx == 4 then
      -- Delete all buffers to left
      for _, buf in ipairs(buffers) do
        if buf.bufnr < current then
          pcall(vim.api.nvim_buf_delete, buf.bufnr, { force = true })
        end
      end
    elseif idx == 5 then
      -- Search and delete single buffer
      local buffer_names = {}
      for _, buf in ipairs(buffers) do
        local name = vim.api.nvim_buf_get_name(buf.bufnr)
        name = name ~= "" and name or "[No Name]"
        table.insert(buffer_names, string.format("[%d] %s", buf.bufnr, name))
      end

      vim.ui.select(buffer_names, {
        prompt = "Select buffer to delete:",
      }, function(selected)
        if not selected then return end
        local bufnr = tonumber(selected:match("%[(%d+)%]"))
        if bufnr then
          if bufnr == current and #buffers > 1 then
            vim.cmd('bprevious')
          end
          pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        end
      end)
    elseif idx == 6 then
      -- Search and delete multiple buffers
      local buffer_list = {}
      for _, buf in ipairs(buffers) do
        local name = vim.api.nvim_buf_get_name(buf.bufnr)
        name = name ~= "" and name or "[No Name]"
        table.insert(buffer_list, {
          bufnr = buf.bufnr,
          display = string.format("[%d] %s", buf.bufnr, name)
        })
      end

      -- Show selection UI multiple times until cancelled
      local selected_buffers = {}
      local function select_next()
        local remaining = {}
        for _, item in ipairs(buffer_list) do
          if not selected_buffers[item.bufnr] then
            table.insert(remaining, item.display)
          end
        end

        if #remaining == 0 then
          -- Delete all selected buffers
          local was_current_selected = selected_buffers[current]
          if was_current_selected and #buffers > #vim.tbl_keys(selected_buffers) then
            vim.cmd('bprevious')
          end

          for bufnr, _ in pairs(selected_buffers) do
            pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
          end
          return
        end

        table.insert(remaining, "--- Done (delete selected buffers) ---")

        vim.ui.select(remaining, {
          prompt = string.format("Select buffers to delete (%d selected):", #vim.tbl_keys(selected_buffers)),
        }, function(selected)
          if not selected or selected:match("^%-%-%-") then
            -- Delete all selected buffers
            local was_current_selected = selected_buffers[current]
            if was_current_selected and #buffers > #vim.tbl_keys(selected_buffers) then
              vim.cmd('bprevious')
            end

            for bufnr, _ in pairs(selected_buffers) do
              pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
            end
            return
          end

          local bufnr = tonumber(selected:match("%[(%d+)%]"))
          if bufnr then
            selected_buffers[bufnr] = true
            select_next()
          end
        end)
      end

      select_next()
    end
  end)
end

return delete_buffer_menu
