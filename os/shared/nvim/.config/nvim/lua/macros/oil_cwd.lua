function oil_cwd()
  require("oil").open(vim.fn.getcwd())
end

return oil_cwd
