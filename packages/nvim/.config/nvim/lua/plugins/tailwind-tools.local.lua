local plugin = require("utils.plugin")

return {
  dir = plugin.dir("tailwind-tools.nvim"),
  name = "tailwind-tools",
  opts = {
    server = {
      settings = {
        experimental = {
          classRegex = {
            { "[a-zA-Z]+`([^`]*)`", "([^`]*)" },
            { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
            { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
            ": `([^`]*)", -- : `...`
            "= `([^`]*)", -- = `...`
            "tw`([^`]*)", -- tw`...`
            "\\$`([^`]*)", -- $`...`
            "classes`([^`]*)", -- classes`...`
            'tw="([^"]*)', -- <div tw="..." />
            "tw='([^']*)", -- <div tw='...' />
            'tw={"([^"}]*)', -- <div tw={"..."} />
            "tw={'([^'}]*)", -- <div tw={'...'} />
            "tw={`([^`}]*)", -- <div tw={`...`} />
            'className="([^"]*)', -- <div className="..." />
            "className='([^']*)", -- <div className='...' />
            'className={"([^"}]*)', -- <div className={"..."} />
            "className={'([^'}]*)", -- <div className={'...'} />
            "className={`([^`}]*)", -- <div className={`...`} />
          },
        },
      },
    },
  },
}
