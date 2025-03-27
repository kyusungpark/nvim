local plugins = {}

-- Core plugins
table.insert(plugins, require("custom.plugins.core"))

-- LSP and completion
table.insert(plugins, require("custom.plugins.lsp"))

-- AI tools
table.insert(plugins, require("custom.plugins.ai"))

-- Editor enhancements
table.insert(plugins, require("custom.plugins.editor"))

-- Session management
table.insert(plugins, require("custom.plugins.session"))

-- Flatten the plugins table
local flattened_plugins = {}
for _, plugin_group in ipairs(plugins) do
  for _, plugin in ipairs(plugin_group) do
    table.insert(flattened_plugins, plugin)
  end
end

return flattened_plugins
