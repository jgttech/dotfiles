local function print_table(tbl, indent)
  indent = indent or 0
  local formatting = string.rep('  ', indent)

  if type(tbl) ~= 'table' then
    print(formatting .. tostring(tbl))
    return
  end

  for k, v in pairs(tbl) do
    local key_str = tostring(k)
    if type(v) == 'table' then
      print(formatting .. key_str .. ':')
      print_table(v, indent + 1)
    else
      local value_str = tostring(v)
      print(formatting .. key_str .. ': ' .. value_str)
    end
  end
end

return print_table
