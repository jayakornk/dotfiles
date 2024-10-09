local M = {}

local provider = require 'jk.utils.status.provider'
local status_utils = require 'jk.utils.status.utils'
local condition = require 'jk.utils.status.condition'
local get_icon = require('jk.utils.icons').get_icon

local extend_tbl = status_utils.extend_tbl

--- A function to build a set of components for a foldcolumn section in a statuscolumn
---@param opts? table options for configuring foldcolumn and the overall padding
---@return table # The Heirline component table
-- @usage local heirline_component = require("astroui.status").component.foldcolumn()
function M.foldcolumn(opts)
  opts = extend_tbl({
    foldcolumn = { padding = { right = 1 } },
    condition = condition.foldcolumn_enabled,
    on_click = {
      name = 'fold_click',
      callback = function(...)
        local char = status_utils.statuscolumn_clickargs(...).char
        local fillchars = vim.opt_local.fillchars:get()
        if char == (fillchars.foldopen or get_icon 'FoldOpened') then
          vim.cmd 'norm! zc'
        elseif char == (fillchars.foldclose or get_icon 'FoldClosed') then
          vim.cmd 'norm! zo'
        end
      end,
    },
  }, opts)
  return M.builder(status_utils.setup_providers(opts, { 'foldcolumn' }))
end

--- A function to build a set of components for a numbercolumn section in statuscolumn
---@param opts? table options for configuring numbercolumn and the overall padding
---@return table # The Heirline component table
-- @usage local heirline_component = require("astroui.status").component.numbercolumn()
function M.numbercolumn(opts)
  opts = extend_tbl({
    numbercolumn = { padding = { right = 1 } },
    condition = condition.numbercolumn_enabled,
    on_click = {
      name = 'line_click',
      callback = function(...)
        local args = status_utils.statuscolumn_clickargs(...)
        if args.mods:find 'c' then
          if status_utils.is_available 'nvim-dap' then
            require('dap').toggle_breakpoint()
          end
        end
      end,
    },
  }, opts)
  return M.builder(status_utils.setup_providers(opts, { 'numbercolumn' }))
end

--- A function to build a set of components for a signcolumn section in statuscolumn
---@param opts? table options for configuring signcolumn and the overall padding
---@return table # The Heirline component table
-- @usage local heirline_component = require("astroui.status").component.signcolumn()
function M.signcolumn(opts)
  local sign_handlers = {}
  -- gitsigns handlers
  local function gitsigns_handler(_)
    local gitsigns_avail, gitsigns = pcall(require, 'gitsigns')
    if gitsigns_avail then
      vim.schedule(gitsigns.preview_hunk)
    end
  end
  for _, sign in ipairs { 'Topdelete', 'Untracked', 'Add', 'Change', 'Changedelete', 'Delete' } do
    local name = 'GitSigns' .. sign
    if not sign_handlers[name] then
      sign_handlers[name] = gitsigns_handler
    end
  end
  sign_handlers['gitsigns_extmark_signs_'] = gitsigns_handler
  -- diagnostic handlers
  local function diagnostics_handler(args)
    if args.mods:find 'c' then
      vim.schedule(vim.lsp.buf.code_action)
    else
      vim.schedule(vim.diagnostic.open_float)
    end
  end
  for _, sign in ipairs { 'Error', 'Hint', 'Info', 'Warn' } do
    local name = 'DiagnosticSign' .. sign
    if not sign_handlers[name] then
      sign_handlers[name] = diagnostics_handler
    end
  end

  opts = extend_tbl({
    signcolumn = {},
    condition = condition.signcolumn_enabled,
    on_click = {
      name = 'sign_click',
      callback = function(...)
        local args = status_utils.statuscolumn_clickargs(...)
        if args.sign then
          local handler = args.sign.name ~= '' and sign_handlers[args.sign.name]
          if not handler then
            handler = sign_handlers[args.sign.namespace]
          end
          if not handler then
            handler = sign_handlers[args.sign.texthl]
          end
          if handler then
            handler(args)
          end
        end
      end,
    },
  }, opts)
  return M.builder(status_utils.setup_providers(opts, { 'signcolumn' }))
end

--- A general function to build a section of astronvim status providers with highlights, conditions, and section surrounding
---@param opts? table a list of components to build into a section
---@return table # The Heirline component table
-- @usage local heirline_component = require("astroui.status").components.builder({ { provider = "file_icon", opts = { padding = { right = 1 } } }, { provider = "filename" } })
function M.builder(opts)
  opts = extend_tbl({ padding = { left = 0, right = 0 } }, opts)
  local children, offset = {}, 0
  if opts.padding.left > 0 then -- add left padding
    table.insert(children, { provider = status_utils.pad_string(' ', { left = opts.padding.left - 1 }) })
    offset = offset + 1
  end
  for key, entry in pairs(opts) do
    if type(key) == 'number' and type(entry) == 'table' and provider[entry.provider] and (entry.opts == nil or type(entry.opts) == 'table') then
      entry.provider = provider[entry.provider](entry.opts)
    end
    if type(key) == 'number' then
      key = key + offset
    end
    children[key] = entry
  end
  if opts.padding.right > 0 then -- add right padding
    table.insert(children, { provider = status_utils.pad_string(' ', { right = opts.padding.right - 1 }) })
  end
  return opts.surround and status_utils.surround(opts.surround.separator, opts.surround.color, children, opts.surround.condition, opts.surround.update)
    or children
end

return M
