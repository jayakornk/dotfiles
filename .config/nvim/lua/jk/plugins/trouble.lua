return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  lazy = false,
  opts = function()
    local get_icon = require('jk.utils.icons').get_icon
    local lspkind_avail, lspkind = pcall(require, 'lspkind')
    return {
      keys = {
        ['<ESC>'] = 'close',
        ['q'] = 'close',
        ['<C-E>'] = 'close',
      },
      icons = {
        indent = {
          fold_open = get_icon 'FoldOpened',
          fold_closed = get_icon 'FoldClosed',
        },
        folder_closed = get_icon 'FolderClosed',
        folder_open = get_icon 'FolderOpen',
        kinds = lspkind_avail and lspkind.symbol_map,
      },
    }
  end,
  keys = {
    { '<leader>xX', '<Cmd>Trouble diagnostics toggle<CR>', desc = 'Trouble Workspace Diagnostics' },
    { '<leader>xx', '<Cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Trouble Document Diagnostics' },
    { '<leader>xL', '<Cmd>Trouble loclist toggle<CR>', desc = 'Trouble Location List' },
    { '<leader>xQ', '<Cmd>Trouble quickfix toggle<CR>', desc = 'Trouble Quickfix List' },
    { '<leader>xt', '<cmd>Trouble todo<cr>', desc = 'Trouble Todo' },
    { '<leader>xT', '<cmd>Trouble todo filter={tag={TODO,FIX,FIXME}}<cr>', desc = 'Trouble Todo/Fix/Fixme' },
  },
  specs = {
    { 'lewis6991/gitsigns.nvim', optional = true, opts = { trouble = true } },
    {
      'folke/edgy.nvim',
      optional = true,
      opts = function(_, opts)
        if not opts.bottom then
          opts.bottom = {}
        end
        table.insert(opts.bottom, 'Trouble')
      end,
    },
  },
}
