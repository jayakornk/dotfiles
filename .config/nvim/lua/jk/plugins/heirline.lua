return {
  'rebelot/heirline.nvim',
  event = 'BufEnter',
  opts = function()
    local component = require 'jk.utils.status.component'
    return {
      statuscolumn = {
        init = function(self)
          self.bufnr = vim.api.nvim_get_current_buf()
        end,
        component.foldcolumn(),
        component.numbercolumn(),
        component.signcolumn(),
      },
    }
  end,
}
