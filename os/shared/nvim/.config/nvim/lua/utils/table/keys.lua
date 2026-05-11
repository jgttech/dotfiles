local function keys(tbl)
  local keys = {}

  for k, _ in pairs(tbl or {}) do
    table.insert(keys, k)
  end

  return keys
end

return keys
