return {
  'stevearc/dressing.nvim',
  lazy = true,
  init = function()
    require('jk.utils.init').load_plugin_with_func('dressing.nvim', vim.ui, { 'input', 'select' })
  end,
  opts = function()
    local get_icon = require('jk.utils.icons').get_icon
    return {
      input = { default_prompt = get_icon('Selected', 1) },
    }
  end,
}
