return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup()

    vim.keymap.set("n", "ho", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = "[H]arpoon [O]pen" })

    vim.keymap.set("n", "ha", function()
      harpoon:list():add()
    end, { desc = "[H]arpoon [A]dd" })

    vim.keymap.set("n", "<leader>1", function()
      harpoon:list():select(1)
    end, { desc = "[H]arpoon #1" })

    vim.keymap.set("n", "<leader>2", function()
      harpoon:list():select(2)
    end, { desc = "[H]arpoon #2" })

    vim.keymap.set("n", "<leader>3", function()
      harpoon:list():select(3)
    end, { desc = "[H]arpoon #3" })

    vim.keymap.set("n", "<leader>4", function()
      harpoon:list():select(4)
    end, { desc = "[H]arpoon #4" })

    vim.keymap.set("n", "<M-h-p>", function()
      harpoon:list():prev()
    end, { desc = "[H]arpoon [P]revious" })

    vim.keymap.set("n", "<M-h-n>", function()
      harpoon:list():next()
    end, { desc = "[H]arpoon [N]ext" })
  end,
}
