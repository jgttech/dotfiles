-- Parrot.nvim configuration for Claude Opus 4.1
return {
  "frankroeder/parrot.nvim",
  dependencies = {
    "ibhagwan/fzf-lua",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("parrot").setup({
      -- Provider settings
      providers = {
        anthropic = {
          name = "anthropic",
          endpoint = "https://api.anthropic.com/v1/messages",
          model_endpoint = "https://api.anthropic.com/v1/models",
          api_key = os.getenv("ANTHROPIC_API_KEY"), -- Set your API key as environment variable

          -- Default model (using Claude Opus 4.1)
          model = "claude-opus-4-1-20250805",

          -- Available models
          models = {
            "claude-opus-4-1-20250805",
            "claude-opus-4-20240521",
            "claude-3-5-sonnet-20241022",
            "claude-3-5-haiku-20241022",
          },

          -- Parameters for different modes
          params = {
            chat = { max_tokens = 4096 },
            command = { max_tokens = 4096 },
          },

          -- Topic model for chat titles (using a smaller model for efficiency)
          topic = {
            model = "claude-3-5-haiku-20241022",
            params = { max_tokens = 32 },
          },

          -- Required headers for Anthropic API
          headers = function(self)
            return {
              ["Content-Type"] = "application/json",
              ["x-api-key"] = self.api_key,
              ["anthropic-version"] = "2023-06-01",
            }
          end,

          -- Required preprocessing for Anthropic's message format
          preprocess_payload = function(payload)
            -- Trim whitespace from messages
            for _, message in ipairs(payload.messages) do
              message.content = message.content:gsub("^%s*(.-)%s*$", "%1")
            end
            -- Convert system message to Anthropic format
            if payload.messages[1] and payload.messages[1].role == "system" then
              payload.system = payload.messages[1].content
              table.remove(payload.messages, 1)
            end
            return payload
          end,
        },
      },

      -- Default provider
      provider = "anthropic",

      -- General settings
      toggle_target = "popup", -- Options: "popup", "split", "vsplit", "tabnew"
      user_input_ui = "buffer", -- Options: "native", "buffer"

      -- Chat settings
      chat = {
        prompt_header = "## Prompt\n",
        answer_header = "## Answer\n",
        sessions_window = {
          border = "single",
          relative = "editor",
          width = 0.3,
          height = 0.6,
        },
      },

      -- Style settings
      style = {
        chat = {
          border = "rounded",
          title = " Claude Chat ",
        },
        popup = {
          border = "rounded",
          max_width = 120,
          max_height = 30,
        },
      },

      -- Template placeholders (these work with commands like PrtRewrite)
      template_placeholders = {
        ["{{selection}}"] = function()
          local start_pos = vim.fn.getpos("'<")
          local end_pos = vim.fn.getpos("'>")
          local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)
          return table.concat(lines, "\n")
        end,
        ["{{filetype}}"] = function()
          return vim.bo.filetype
        end,
        ["{{input}}"] = function()
          return vim.fn.input("Enter input: ")
        end,
        ["{{filepath}}"] = function()
          return vim.fn.expand("%:p")
        end,
        ["{{filename}}"] = function()
          return vim.fn.expand("%:t")
        end,
      },

      -- Additional options
      log_level = "info", -- Options: "trace", "debug", "info", "warn", "error"
      log_file = vim.fn.stdpath("data") .. "/parrot.log",
    })

    -- Set up keymaps using the CORRECT command names
    local map = vim.keymap.set

    -- Chat commands (using PrtChatToggle, PrtChatNew, etc.)
    map("n", "<leader>cc", "<cmd>PrtChatToggle<cr>", { desc = "Toggle Claude chat" })
    map("n", "<leader>cn", "<cmd>PrtChatNew<cr>", { desc = "New Claude chat" })
    map("n", "<leader>cf", "<cmd>PrtChatFinder<cr>", { desc = "Find Claude chats" })
    map("n", "<leader>cs", "<cmd>PrtStop<cr>", { desc = "Stop Claude generation" })
    map("n", "<leader>cr", "<cmd>PrtChatRespond<cr>", { desc = "Generate Claude response" })

    -- Visual mode commands for code operations
    map("v", "<leader>cr", "<cmd>PrtRewrite<cr>", { desc = "Rewrite with Claude" })
    map("v", "<leader>ca", "<cmd>PrtAppend<cr>", { desc = "Append with Claude" })
    map("v", "<leader>cp", "<cmd>PrtPrepend<cr>", { desc = "Prepend with Claude" })
    map("v", "<leader>ce", "<cmd>PrtEdit<cr>", { desc = "Edit with Claude" })

    -- Visual mode chat integration
    map("v", "<leader>cc", "<cmd>PrtChatPaste<cr>", { desc = "Paste to Claude chat" })

    -- Model/Provider management
    map("n", "<leader>cm", "<cmd>PrtModel<cr>", { desc = "Select Claude model" })
    map("n", "<leader>cx", "<cmd>PrtProvider<cr>", { desc = "Select provider" })
    map("n", "<leader>ct", "<cmd>PrtStatus<cr>", { desc = "Show Claude status" })
  end,
}
