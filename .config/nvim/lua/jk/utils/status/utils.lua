local get_icon = require('jk.utils.icons').get_icon

local M = {}

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend('force', default, opts) or opts
end

--- Get a plugin spec from lazy
---@param plugin string The plugin to search for
---@return LazyPlugin? available # The found plugin spec from Lazy
function M.get_plugin(plugin)
  local lazy_config_avail, lazy_config = pcall(require, 'lazy.core.config')
  return lazy_config_avail and lazy_config.spec.plugins[plugin] or nil
end

--- Check if a plugin is defined in lazy. Useful with lazy loading when a plugin is not necessarily loaded yet
---@param plugin string The plugin to search for
---@return boolean available # Whether the plugin is available
function M.is_available(plugin)
  return M.get_plugin(plugin) ~= nil
end

--- Convert a component parameter table to a table that can be used with the component builder
---@param opts? table a table of provider options
---@param provider? function|string a provider in `M.providers`
---@return table|false # the provider table that can be used in `M.component.builder`
function M.build_provider(opts, provider, _)
  return opts
      and {
        provider = provider,
        opts = opts,
        condition = opts.condition,
        on_click = opts.on_click,
        update = opts.update,
        hl = opts.hl,
      }
    or false
end

--- Convert key/value table of options to an array of providers for the component builder
---@param opts table the table of options for the components
---@param providers string[] an ordered list like array of providers that are configured in the options table
---@param setup? function a function that takes provider options table, provider name, provider index and returns the setup provider table, optional, default is `M.build_provider`
---@return table # the fully setup options table with the appropriately ordered providers
function M.setup_providers(opts, providers, setup)
  setup = setup or M.build_provider
  for i, provider in ipairs(providers) do
    opts[i] = setup(opts[provider], provider, i)
  end
  return opts
end

--- A utility function to get the width of the bar
---@param is_winbar? boolean true if you want the width of the winbar, false if you want the statusline width
---@return integer # the width of the specified bar
function M.width(is_winbar)
  return vim.o.laststatus == 3 and not is_winbar and vim.o.columns or vim.api.nvim_win_get_width(0)
end

--- Add left and/or right padding to a string
---@param str string the string to add padding to
---@param padding table a table of the format `{ left = 0, right = 0}` that defines the number of spaces to include to the left and the right of the string
---@return string # the padded string
function M.pad_string(str, padding)
  padding = padding or {}
  return str and str ~= '' and (' '):rep(padding.left or 0) .. str .. (' '):rep(padding.right or 0) or ''
end

local function escape(str)
  return str:gsub('%%', '%%%%')
end

--- A utility function to stylize a string with an icon from lspkind, separators, and left/right padding
---@param str? string the string to stylize
---@param opts? table options of `{ padding = { left = 0, right = 0 }, separator = { left = "|", right = "|" }, escape = true, show_empty = false, icon = { kind = "NONE", padding = { left = 0, right = 0 } } }`
---@return string # the stylized string
-- @usage local string = require("astroui.status").utils.stylize("Hello", { padding = { left = 1, right = 1 }, icon = { kind = "String" } })
function M.stylize(str, opts)
  opts = M.extend_tbl({
    padding = { left = 0, right = 0 },
    separator = { left = '', right = '' },
    show_empty = false,
    escape = true,
    icon = { kind = 'NONE', padding = { left = 0, right = 0 } },
  }, opts)
  local icon = M.pad_string(get_icon(opts.icon.kind), opts.icon.padding)
  return str
      and (str ~= '' or opts.show_empty)
      and opts.separator.left .. M.pad_string(icon .. (opts.escape and escape(str) or str), opts.padding) .. opts.separator.right
    or ''
end

--- Surround component with separator and color adjustment
---@param separator string|string[] the separator index to use in the `separators` table
---@param color function|string|table the color to use as the separator foreground/component background
---@param component table the component to surround
---@param condition boolean|function the condition for displaying the surrounded component
---@param update AstroUIUpdateEvents? control updating of separators, either a list of events or true to update freely
---@return table # the new surrounded component
function M.surround(separator, color, component, condition, update)
  local function surround_color(self)
    local colors = type(color) == 'function' and color(self) or color
    return type(colors) == 'string' and { main = colors } or colors
  end

  separator = type(separator) == 'string' and config.separators[separator] or separator
  local surrounded = { condition = condition }
  local base_separator = {
    update = (update or type(color) ~= 'function') and function()
      return false
    end,
    init = update and require('astroui.status.init').update_events(update),
  }
  if separator[1] ~= '' then
    table.insert(
      surrounded,
      extend_tbl {
        provider = separator[1], --bind alt-j:down,alt-k:up
        hl = function(self)
          local s_color = surround_color(self)
          if s_color then
            return { fg = s_color.main, bg = s_color.left }
          end
        end,
      }
    )
  end
  local component_hl = component.hl
  component.hl = function(self)
    local hl = {}
    if component_hl then
      hl = type(component_hl) == 'table' and vim.deepcopy(component_hl) or component_hl(self)
    end
    local s_color = surround_color(self)
    if s_color then
      hl.bg = s_color.main
    end
    return hl
  end
  table.insert(surrounded, component)
  if separator[2] ~= '' then
    table.insert(
      surrounded,
      extend_tbl(base_separator, {
        provider = separator[2],
        hl = function(self)
          local s_color = surround_color(self)
          if s_color then
            return { fg = s_color.main, bg = s_color.right }
          end
        end,
      })
    )
  end
  return surrounded
end

--- Get highlight properties for a given highlight name
---@param name string The highlight group name
---@param fallback? table The fallback highlight properties
---@return table properties # the highlight group properties
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if not hl.fg then
      hl.fg = 'NONE'
    end
    if not hl.bg then
      hl.bg = 'NONE'
    end
    if hl.reverse then
      hl.fg, hl.bg, hl.reverse = hl.bg, hl.fg, nil
    end
    return hl
  end
  return fallback or {}
end

---@type false|fun(bufname: string, filetype: string, buftype: string): string?,string?
local cached_icon_provider
--- Resolve the icon and color information for a given buffer
---@param bufnr integer the buffer number to resolve the icon and color of
---@return string? icon the icon string
---@return string? color the hex color of the icon
function M.icon_provider(bufnr)
  if not bufnr then
    bufnr = 0
  end
  local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
  local filetype = vim.bo[bufnr].filetype
  local buftype = vim.bo[bufnr].buftype
  if cached_icon_provider then
    return cached_icon_provider(bufname, filetype, buftype)
  end
  if cached_icon_provider == false then
    return
  end

  local _, mini_icons = pcall(require, 'mini.icons')
  -- mini.icons
  if _G.MiniIcons then
    cached_icon_provider = function(_bufname, _filetype)
      local icon, hl, is_default = mini_icons.get('file', _bufname)
      if is_default then
        icon, hl, is_default = mini_icons.get('filetype', _filetype)
      end
      local color = M.get_hlgroup(hl).fg
      if type(color) == 'number' then
        color = string.format('#%06x', color)
      end
      return icon, color
    end
    return cached_icon_provider(bufname, filetype, bufname)
  end

  -- nvim-web-devicons
  local devicons_avail, devicons = pcall(require, 'nvim-web-devicons')
  if devicons_avail then
    cached_icon_provider = function(_bufname, _filetype, _buftype)
      local icon, color = devicons.get_icon_color(_bufname)
      if not color then
        icon, color = devicons.get_icon_color_by_filetype(_filetype, { default = _buftype == '' })
      end
      return icon, color
    end
    return cached_icon_provider(bufname, filetype, buftype)
  end

  -- fallback to no icon provider
  cached_icon_provider = false
end

--- A helper function for decoding statuscolumn click events with mouse click pressed, modifier keys, as well as which signcolumn sign was clicked if any
---@param self any the self parameter from Heirline component on_click.callback function call
---@param minwid any the minwid parameter from Heirline component on_click.callback function call
---@param clicks any the clicks parameter from Heirline component on_click.callback function call
---@param button any the button parameter from Heirline component on_click.callback function call
---@param mods any the button parameter from Heirline component on_click.callback function call
---@return table # the argument table with the decoded mouse information and signcolumn signs information
-- @usage local heirline_component = { on_click = { callback = function(...) local args = require("astroui.status").utils.statuscolumn_clickargs(...) end } }
function M.statuscolumn_clickargs(self, minwid, clicks, button, mods)
  local args = {
    minwid = minwid,
    clicks = clicks,
    button = button,
    mods = mods,
    mousepos = vim.fn.getmousepos(),
  }
  args.char = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol)
  if args.char == ' ' then
    args.char = vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol - 1)
  end

  if not self.signs then
    self.signs = {}
  end
  args.sign = self.signs[args.char]
  if not args.sign then -- update signs if not found on first click
    ---TODO: remove when dropping support for Neovim v0.9
    if vim.fn.has 'nvim-0.10' == 0 then
      for _, sign_def in ipairs(assert(vim.fn.sign_getdefined())) do
        if sign_def.text then
          self.signs[sign_def.text:gsub('%s', '')] = sign_def
        end
      end
    end

    if not self.bufnr then
      self.bufnr = vim.api.nvim_get_current_buf()
    end
    local row = args.mousepos.line - 1
    for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(self.bufnr, -1, { row, 0 }, { row, -1 }, { details = true, type = 'sign' })) do
      local sign = extmark[4]
      if not (self.namespaces and self.namespaces[sign.ns_id]) then
        self.namespaces = {}
        for ns, ns_id in pairs(vim.api.nvim_get_namespaces()) do
          self.namespaces[ns_id] = ns
        end
      end
      if sign.sign_text then
        self.signs[sign.sign_text:gsub('%s', '')] = {
          name = sign.sign_name,
          text = sign.sign_text,
          texthl = sign.sign_hl_group or 'NoTexthl',
          namespace = sign.ns_id and self.namespaces[sign.ns_id],
        }
      end
    end
    args.sign = self.signs[args.char]
  end
  vim.api.nvim_set_current_win(args.mousepos.winid)
  vim.api.nvim_win_set_cursor(0, { args.mousepos.line, 0 })
  return args
end

return M
