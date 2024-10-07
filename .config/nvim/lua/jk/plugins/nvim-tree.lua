return {
  'nvim-tree/nvim-tree.lua',
  cmd = { 'NvimTreeToggle', 'NvimTreeFocus' },
  opts = function()
    local VIEW_WIDTH_FIXED = 30
    local view_width_max = VIEW_WIDTH_FIXED -- fixed to start

    -- toggle the width and redraw
    local function toggle_width_adaptive()
      if view_width_max == -1 then
        view_width_max = VIEW_WIDTH_FIXED
      else
        view_width_max = -1
      end

      require('nvim-tree.api').tree.reload()
    end

    -- get current view width
    local function get_view_width_max()
      return view_width_max
    end

    local function my_on_attach(bufnr)
      local api = require 'nvim-tree.api'

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', 'A', toggle_width_adaptive, opts 'Toggle Adaptive Width')
      -- vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("Up"))
      vim.keymap.set('n', '?', api.tree.toggle_help, opts 'Help')
    end

    return {
      filters = { dotfiles = false },
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      on_attach = my_on_attach,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        width = {
          min = 30,
          max = get_view_width_max,
        },
        preserve_window_proportions = true,
      },
      diagnostics = {
        enable = true,
        -- show_on_dirs = true,
      },
      renderer = {
        root_folder_label = false,
        highlight_git = true,
        indent_markers = { enable = true },
        icons = {
          glyphs = {
            default = '󰈚',
            folder = {
              default = '',
              empty = '',
              empty_open = '',
              open = '',
              symlink = '',
            },
            git = { unmerged = '' },
          },
        },
      },
    }
  end,
}
