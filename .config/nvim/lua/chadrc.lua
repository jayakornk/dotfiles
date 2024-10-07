local M = {}

M.base46 = {
  theme = 'catppuccin',
  transparency = true,
  hl_override = {
    FoldColumn = { bg = 'NONE' },
  },
  theme_toggle = { 'onedark', 'catppuccin' },
}

M.ui = {
  cmp = {
    icons_left = true,
    style = 'default',
    format_colors = {
      tailwind = true, -- will work for css lsp too
    },
  },
  statusline = {
    theme = 'minimal',
    separator_style = 'round',
  },
}

M.nvdash = {
  load_on_startup = true,
  buttons = {
    { txt = '  Find File', keys = 'Spc f f', cmd = 'Telescope find_files' },
    { txt = '  Recent Files', keys = 'Spc f r', cmd = 'Telescope oldfiles' },
    { txt = '󰈭  Find Word', keys = 'Spc s g', cmd = 'Telescope live_grep' },
    { txt = '󱥚  Themes', keys = 'Spc t h', cmd = ":lua require('nvchad.themes').open()" },
    { txt = '  Mappings', keys = 'Spc l h', cmd = 'NvCheatsheet' },

    { txt = '─', hl = 'NvDashLazy', no_gap = true, rep = true },

    {
      txt = function()
        local stats = require('lazy').stats()
        local ms = math.floor(stats.startuptime) .. ' ms'
        return '  Loaded ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms
      end,
      hl = 'NvDashLazy',
      no_gap = true,
    },

    { txt = '─', hl = 'NvDashLazy', no_gap = true, rep = true },
  },
}

return M
