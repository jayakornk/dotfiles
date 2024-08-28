local colors = {
  blue = '#80a0ff',
  cyan = '#79dac8',
  black = '#080808',
  white = '#c6c6c6',
  red = '#ff5189',
  violet = '#d183e8',
  grey = '#303030',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.white },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.white },
  },
}

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = function(plugin)
    local lazy_status = require 'lazy.status' -- to configure lazy pending updates count

    return {
      options = {
        theme = 'catppuccin',
        section_separators = { left = '', right = '' },
        component_separators = '',
        globalstatus = true,
        disabled_filetypes = { statusline = { 'dashboard', 'lazy', 'alpha' } },
      },
      sections = {
        lualine_a = {
          { 'mode', separator = { left = '' }, right_padding = 2 },
          {
            'macro-recording',
            fmt = function()
              local recording_register = vim.fn.reg_recording()
              if recording_register == '' then
                return ''
              else
                return 'Recording @' .. recording_register
              end
            end,
          },
        },
        lualine_b = { 'branch', 'diff', 'diagnostics', 'filename' },
        lualine_c = {
          '%=', --[[ add your center compoentnts here in place of this comment ]]
        },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = '#ff9e64' },
          },
          -- { 'encoding' },
          -- { 'fileformat' },
        },
        lualine_y = { 'filetype', 'progress' },
        lualine_z = {
          { 'location', separator = { right = '' }, left_padding = 2 },
        },
      },
      inactive_sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'location' },
      },
      extensions = { 'nvim-tree' },
    }
  end,
  config = function(_, opts)
    local lualine = require 'lualine'

    lualine.setup(opts)
    vim.api.nvim_create_autocmd('RecordingEnter', {
      callback = function()
        -- refresh lualine when entering record mode
        lualine.refresh { place = { 'lualine_a' } }
      end,
    })
  end,
}
