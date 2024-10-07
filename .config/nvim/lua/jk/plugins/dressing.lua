return {
  'stevearc/dressing.nvim',
  -- lazy = true,
  opts = function()
    local get_icon = require('jk.utils.icons').get_icon
    return {
      input = { default_prompt = get_icon('Selected', 1) },
    }
  end,
}
