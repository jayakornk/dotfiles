local M = {}

function M.is_loaded(name)
  local Config = require 'lazy.core.config'
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

--- A helper function to wrap a module function to require a plugin before running
---@param plugin string The plugin to call `require("lazy").load` with
---@param module table The system module where the functions live (e.g. `vim.ui`)
---@param funcs string|string[] The functions to wrap in the given module (e.g. `"ui", "select"`)
function M.load_plugin_with_func(plugin, module, funcs)
  if type(funcs) == 'string' then
    funcs = { funcs }
  end
  for _, func in ipairs(funcs) do
    local old_func = module[func]
    module[func] = function(...)
      module[func] = old_func
      require('lazy').load { plugins = { plugin } }
      module[func](...)
    end
  end
end

return M
