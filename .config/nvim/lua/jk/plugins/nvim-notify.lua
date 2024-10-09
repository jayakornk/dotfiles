return {
  'rcarriga/nvim-notify',
  lazy = true,
  keys = {
    {
      '<leader>un',
      function()
        require('notify').dismiss { silent = true, pending = true }
      end,
      desc = 'Dismiss All Notifications',
    },
  },
  init = function()
    require('jk.utils.init').load_plugin_with_func('nvim-notify', vim, 'notify')
  end,
  -- opts = {
  --   stages = 'static',
  --   timeout = 3000,
  --   max_height = function()
  --     return math.floor(vim.o.lines * 0.75)
  --   end,
  --   max_width = function()
  --     return math.floor(vim.o.columns * 0.75)
  --   end,
  --   on_open = function(win)
  --     vim.api.nvim_win_set_config(win, { zindex = 100 })
  --   end,
  -- },
  opts = function(_, opts)
    local get_icon = require('jk.utils.icons').get_icon
    opts.icons = {
      DEBUG = get_icon 'Debugger',
      ERROR = get_icon 'DiagnosticError',
      INFO = get_icon 'DiagnosticInfo',
      TRACE = get_icon 'DiagnosticHint',
      WARN = get_icon 'DiagnosticWarn',
    }
    opts.max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end
    opts.max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end
    opts.on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 175 })
      if require('jk.utils.status.utils').is_available 'nvim-treesitter' then
        require('lazy').load { plugins = { 'nvim-treesitter' } }
      end
      vim.wo[win].conceallevel = 3
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, 'markdown') then
        vim.bo[buf].syntax = 'markdown'
      end
      vim.wo[win].spell = false
    end
  end,
}
