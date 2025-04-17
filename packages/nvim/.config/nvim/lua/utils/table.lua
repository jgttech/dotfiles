local M = {}

M.merge = function(t1, t2)
  local t = {}

  -- Copy key-value pairs
  for k, v in pairs(t1 or {}) do
    t[k] = v
  end

  for k, v in pairs(t2 or {}) do
    t[k] = v
  end

  -- Concatenate arrays
  local t1_len = #t1
  for i = 1, #t2 do
    t[t1_len + i] = t2[i]
  end

  return t
end

M.keys = function(tbl)
  local keys = {}

  for k, _ in pairs(tbl or {}) do
    table.insert(keys, k)
  end

  return keys
end

return M
