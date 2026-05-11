return {
  "SmiteshP/nvim-navic",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  opts = {
    icons = {
      File          = "󰈙 ",
      Module        = " ",
      Namespace     = "󰌗 ",
      Package       = " ",
      Class         = "󰌗 ",
      Method        = "󰆧 ",
      Property      = " ",
      Field         = " ",
      Constructor   = " ",
      Enum          = "󰕘 ",
      Interface     = "󰕘 ",
      Function      = "󰊕 ",
      Variable      = "󰆧 ",
      Constant      = "󰏿 ",
      String        = "󰀬 ",
      Number        = "󰎠 ",
      Boolean       = "◩ ",
      Array         = "󰅪 ",
      Object        = "󰅩 ",
      Key           = "󰌋 ",
      Null          = "󰟢 ",
      EnumMember    = " ",
      Struct        = "󰌗 ",
      Event         = " ",
      Operator      = "󰆕 ",
      TypeParameter = "󰊄 ",
    },
    lsp = {
      auto_attach = true, -- Automatically attach to LSP servers
      preference = nil,   -- If multiple servers attach, use this order
    },
    highlight = true,
    separator = " > ",
    depth_limit = 0, -- 0 = no limit
    depth_limit_indicator = "..",
    safe_output = true,
    lazy_update_context = false,
    click = true, -- Enable mouse clicks on breadcrumbs
  },
}
