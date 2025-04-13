return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
      [[                                                                                              ]],
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
      [[                                                                                              ]],
      [[                                                                                              ]],
    }

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
