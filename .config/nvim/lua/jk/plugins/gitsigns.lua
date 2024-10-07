return {
  'lewis6991/gitsigns.nvim',
  enabled = vim.fn.executable 'git' == 1,
  event = { 'BufReadPost', 'BufNewFile', 'BufWritePost' },
  opts = function()
    -- local get_icon = require("jk.utils.icons").get_icon
    return {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      on_attach = function(buffer)
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        map('n', '<leader>ghb', function()
          require('gitsigns').blame_line { full = true }
        end, 'View full Git blame')
        map('n', '<leader>ghB', function()
          require('gitsigns').blame()
        end, 'View Git blame buffer')
        map('n', '<leader>ghl', function()
          require('gitsigns').blame_line()
        end, 'View Git blame')
        map('n', '<leader>ghp', function()
          require('gitsigns').preview_hunk_inline()
        end, 'Preview Git hunk')
        map('n', '<leader>ghr', function()
          require('gitsigns').reset_hunk()
        end, 'Reset Git hunk')
        map('v', '<leader>ghr', function()
          require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Reset Git hunk')
        map('n', '<leader>ghR', function()
          require('gitsigns').reset_buffer()
        end, 'Reset Git buffer')
        map('n', '<leader>ghs', function()
          require('gitsigns').stage_hunk()
        end, 'Stage Git hunk')
        map('v', '<leader>ghs', function()
          require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, 'Stage Git hunk')
        map('n', '<leader>ghS', function()
          require('gitsigns').stage_buffer()
        end, 'Stage Git buffer')
        map('n', '<leader>ghu', function()
          require('gitsigns').undo_stage_hunk()
        end, 'Unstage Git hunk')
        map('n', '<leader>ghd', function()
          require('gitsigns').diffthis()
        end, 'View Git diff')

        map('n', ']g', function()
          require('gitsigns').next_hunk()
        end, 'Next Git hunk')
        map('n', '[g', function()
          require('gitsigns').prev_hunk()
        end, 'Previous Git hunk')

        map({ 'o', 'x' }, 'ig', ':<C-U>Gitsigns select_hunk<CR>', 'inside Git hunk')
      end,
    }
  end,
}
