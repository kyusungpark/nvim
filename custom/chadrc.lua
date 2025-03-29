---@type ChadrcConfig
local M = {}

M.ui = { theme = 'doomchad' }
M.plugins = "custom.plugins"
M.mappings = require "custom.configs.mappings"

-- Load custom initialization
require "custom.init"

return M
