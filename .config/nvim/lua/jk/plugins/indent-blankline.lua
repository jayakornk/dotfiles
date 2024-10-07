return {
  'lukas-reineke/indent-blankline.nvim',
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
  cmd = { 'IBLEnable', 'IBLDisable', 'IBLToggle', 'IBLEnableScope', 'IBLDisableScope', 'IBLToggleScope' },
  keys = {
    { '<leader>u|', '<cmd>IBLToggle<cr>', desc = 'Toggle indent guides' },
  },
  opts = function()
    return {
      indent = {
        char = '▏',
        tab_char = '▏',
      },
      scope = { show_start = false, show_end = false },
      exclude = {
        buftypes = {
          'nofile',
          'prompt',
          'quickfix',
          'terminal',
        },
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
      },
    }
  end,
  main = 'ibl',
}
