local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(path) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, path })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})

    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(path)

-- Setup settings
require("config.settings")
require("config.autocmd")
require("config.keymap")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },

  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Load the colorscheme here
vim.cmd.colorscheme("kanagawa")
