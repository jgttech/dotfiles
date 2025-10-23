local function merge(t1, t2)
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

return merge
