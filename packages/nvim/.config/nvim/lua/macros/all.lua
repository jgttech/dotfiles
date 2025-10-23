local goto_next = require("macros.goto_next")
local goto_prev = require("macros.goto_prev")
local oil_cwd = require("macros.oil_cwd")
local close_buffer = require("macros.close_buffer")
local close_other_buffers = require("macros.close_other_buffers")
local delete_buffer_menu = require("macros.delete_buffer_menu")

local M = {}

M.oil_cwd = oil_cwd
M.goto_next = goto_next
M.goto_prev = goto_prev
M.close_buffer = close_buffer
M.close_other_buffers = close_other_buffers
M.delete_buffer_menu = delete_buffer_menu

return M
