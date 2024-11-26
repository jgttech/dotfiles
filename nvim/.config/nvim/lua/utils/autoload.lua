local function strip_extension(filename)
  return filename:gsub("%.%w+$", "")
end

local function find_files(directory)
  local command
  if package.config:sub(1,1) == '\\' then
    -- Windows
    command = 'dir "' .. directory .. '" /b'
  else
    -- Unix-like
    command = 'ls "' .. directory .. '"'
  end

  local p = io.popen(command)

  if not p then
    return nil, "Failed to open directory"
  end

  local files = {}

  for file in p:lines() do
    table.insert(files, file)
  end

  p:close()

  return files
end

local function autoload(should_return)
  local can_return = should_return or true
  local function loader(path)
    local modules = {}

    if path ~= nil then
      local base_path = vim.fn.stdpath("config") .. "/lua/" .. path
      local files = find_files(base_path)

      for _, value in pairs(files) do
        local import = path .. "." .. strip_extension(value)
        local module = require(import)

	if can_return then
	  table.insert(modules, module)
	end
      end
    end

    if can_return then
      return modules
    end

    return nil
  end

  return loader
end

return autoload
