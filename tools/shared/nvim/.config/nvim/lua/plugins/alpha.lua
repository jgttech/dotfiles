local alpha_header = {
  [[                                                                                              ]],
  [[     .....                                              _            .                        ]],
  [[  .H8888888h.  ~-.                         .uef^"      u            @88>                      ]],
  [[  888888888888x  `>                      :d88E        88Nu.   u.    %8P      ..    .     :    ]],
  [[ X~     `?888888hx~      .u          .   `888E       '88888.o888c    .     .888: x888  x888.  ]],
  [[ '      x8.^"*88*"    ud8888.   .udR88N   888E .z8k   ^8888  8888  .@88u  ~`8888~'888X`?888f` ]],
  [[  `-:- X8888x       :888'8888. <888'888k  888E~?888L   8888  8888 ''888E`   X888  888X '888>  ]],
  [[       488888>      d888 '88%" 9888 'Y"   888E  888E   8888  8888   888E    X888  888X '888>  ]],
  [[     .. `"88*       8888.+"    9888       888E  888E   8888  8888   888E    X888  888X '888>  ]],
  [[   x88888nX"      . 8888L      9888       888E  888E  .8888b.888P   888E    X888  888X '888>  ]],
  [[  !"*8888888n..  :  '8888c. .+ ?8888u../  888E  888E   ^Y8888*""    888&   "*88%""*88" '888!` ]],
  [[ '    "*88888888*    "88888%    "8888P'  m888N= 888>     `Y"        R888"    `~    "    `"`   ]],
  [[         ^"***"`       "YP'       "P'     `Y"   888                  ""                       ]],
  [[                                               J88"                                           ]],
  [[                                               @%                                             ]],
  [[                                             :"                                               ]],
}

return {
  'goolord/alpha-nvim',
  dependencies = {
    'echasnovski/mini.icons',
    'nvim-lua/plenary.nvim'
  },
  config = function()
    local alpha = require("alpha")
    local theta = require("alpha.themes.theta")
    local dashboard = require("alpha.themes.dashboard")
    local config = theta.config

    -- Define custom highlight group for purple icons
    vim.api.nvim_set_hl(0, "AlphaIcon", { fg = "#957FB8" }) -- Kanagawa oniViolet

    -- Helper function to create button with colored icon
    local function button_with_icon(sc, icon, text, cmd)
      local button = dashboard.button(sc, icon .. "  " .. text, cmd)
      button.opts.hl = { { "AlphaIcon", 0, #icon } } -- Apply purple to icon only
      button.opts.hl_shortcut = "Keyword"            -- Match Recent Files section
      return button
    end

    -- Update header
    config.layout[2].val = alpha_header

    -- Update buttons (theta uses layout[6] for buttons)
    config.layout[6] = {
      type = "group",
      val = {
        { type = "text",    val = "Quick links", opts = { hl = "SpecialComment", position = "center" } },
        { type = "padding", val = 1 },
        button_with_icon("e", "❖", "New file", "<cmd>ene<CR>"),
        button_with_icon("SPC s f", "❖", "Find file"),
        button_with_icon("SPC s g", "❖", "Live grep"),
        button_with_icon("c", "❖", "Configuration", "<cmd>cd " .. vim.fn.stdpath('config') .. "<CR>"),
        button_with_icon("u", "❖", "Update plugins", "<cmd>Lazy sync<CR>"),
        button_with_icon("q", "❖", "Quit", "<cmd>qa<CR>"),
      },
      position = "center",
    }

    alpha.setup(config)
  end
};
