local plugins = {}



table.insert(plugins, require("custom.plugins.lsp"))
table.insert(plugins, require("custom.plugins.mason"))
table.insert(plugins, require("custom.plugins.ai"))
table.insert(plugins, require("custom.plugins.editor"))
table.insert(plugins, require("custom.plugins.session"))
table.insert(plugins, require("custom.plugins.highlight"))

-- Flatten the plugins table
local flattened_plugins = {}
for _, plugin_group in ipairs(plugins) do
  for _, plugin in ipairs(plugin_group) do
    table.insert(flattened_plugins, plugin)
  end
end

return flattened_plugins
