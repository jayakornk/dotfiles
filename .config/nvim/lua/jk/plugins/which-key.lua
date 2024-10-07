local get_icon = require('jk.utils.icons').get_icon

return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  opts = {
    icons = {
      group = vim.g.icons_enabled ~= false and '' or '+',
      -- rules = false,
      separator = '-',
    },

    -- Document existing key chains
    spec = {
      {
        mode = { 'n', 'v' },
        { '<leader><tab>', group = 'tabs' },
        { '<leader>l', group = 'code' },
        { '<leader>f', group = 'file/find' },
        { '<leader>g', group = 'git' },
        { '<leader>gh', group = 'hunks' },
        -- { "<leader>q", group = "quit/session" },
        { '<leader>s', group = 'search' },
        { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
        { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
        { '<leader>r', group = 'rest', icon = '󰳘' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
        { 'g', group = 'goto' },
        { 'gs', group = 'surround' },
        { 'z', group = 'fold' },
        {
          '<leader>b',
          group = 'buffer',
          expand = function()
            return require('which-key.extras').expand.buf()
          end,
          icon = get_icon 'Tab',
        },
      },
    },
  },
}
