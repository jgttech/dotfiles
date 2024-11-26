local function keys(tbl)
  local tbl_keys = {}

  for k, _ in pairs(tbl or {}) do
    table.insert(tbl_keys, k)
  end

  return tbl_keys
end

return keys
