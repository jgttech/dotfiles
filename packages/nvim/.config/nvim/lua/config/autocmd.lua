-- Disable treesitter on markdown buffers to avoid nil node crashes
-- in Neovim 0.12.0's injection parsing (affects highlighter, autotag, snacks, etc.)
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable treesitter highlighting for markdown (injection parsing bug)",
  group = vim.api.nvim_create_augroup("markdown-treesitter-fix", { clear = true }),
  pattern = "markdown",
  callback = function(args)
    vim.treesitter.stop(args.buf)
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
