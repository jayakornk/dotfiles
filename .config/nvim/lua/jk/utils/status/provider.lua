local status_utils = require 'jk.utils.status.utils'
local condition = require 'jk.utils.status.condition'
local get_icon = require('jk.utils.icons').get_icon

local extend_tbl = status_utils.extend_tbl

local M = {}

--- A provider function for the fill string
---@return string # the statusline string for filling the empty space
-- @usage local heirline_component = { provider = require("astroui.status").provider.fill }
function M.fill()
  return '%='
end

--- A provider function for the signcolumn string
---@param opts? table options passed to the stylize function
---@return string # the statuscolumn string for adding the signcolumn
-- @usage local heirline_component = { provider = require("astroui.status").provider.signcolumn }
-- @see astroui.status.utils.stylize
function M.signcolumn(opts)
  opts = extend_tbl({ escape = false }, opts)
  return status_utils.stylize('%s', opts)
end

-- local function to resolve the first sign in the signcolumn
-- specifically for usage when `signcolumn=number`
local function resolve_sign(bufnr, lnum)
  --- TODO: remove when dropping support for Neovim v0.9
  if vim.fn.has 'nvim-0.10' == 0 then
    for _, sign in ipairs(vim.fn.sign_getplaced(bufnr, { group = '*', lnum = lnum })[1].signs) do
      local defined = vim.fn.sign_getdefined(sign.name)[1]
      if defined then
        return defined
      end
    end
  end

  local row = lnum - 1
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, -1, { row, 0 }, { row, -1 }, { details = true, type = 'sign' })
  local ret
  for _, extmark in pairs(extmarks) do
    local sign_def = extmark[4]
    if sign_def.sign_text and (not ret or (ret.priority < sign_def.priority)) then
      ret = sign_def
    end
  end
  if ret then
    return { text = ret.sign_text, texthl = ret.sign_hl_group }
  end
end

--- A provider function for the numbercolumn string
---@param opts? table options passed to the stylize function
---@return function # the statuscolumn string for adding the numbercolumn
-- @usage local heirline_component = { provider = require("astroui.status").provider.numbercolumn }
-- @see astroui.status.utils.stylize
function M.numbercolumn(opts)
  opts = extend_tbl({ thousands = false, culright = true, escape = false }, opts)
  return function(self)
    local lnum, rnum, virtnum = vim.v.lnum, vim.v.relnum, vim.v.virtnum
    local num, relnum = vim.opt.number:get(), vim.opt.relativenumber:get()
    local bufnr = self and self.bufnr or 0
    local sign = vim.opt.signcolumn:get():find 'nu' and resolve_sign(bufnr, lnum)
    local str
    if virtnum ~= 0 then
      str = '%='
    elseif sign then
      str = sign.text
      if sign.texthl then
        str = '%#' .. sign.texthl .. '#' .. str .. '%*'
      end
      str = '%=' .. str
    elseif not num and not relnum then
      str = '%='
    else
      local cur = relnum and (rnum > 0 and rnum or (num and lnum or 0)) or lnum
      if opts.thousands and cur > 999 then
        cur = cur:reverse():gsub('%d%d%d', '%1' .. opts.thousands):reverse():gsub('^%' .. opts.thousands, '')
      end
      str = (rnum == 0 and not opts.culright and relnum) and cur .. '%=' or '%=' .. cur
    end
    return status_utils.stylize(str, opts)
  end
end

--- A provider function for building a foldcolumn
---@param opts? table options passed to the stylize function
---@return function # a custom foldcolumn function for the statuscolumn that doesn't show the nest levels
-- @usage local heirline_component = { provider = require("astroui.status").provider.foldcolumn }
-- @see astroui.status.utils.stylize
function M.foldcolumn(opts)
  opts = extend_tbl({ escape = false }, opts)
  local ffi = require 'jk.utils.status.ffi' -- get AstroUI C extensions
  local fillchars = vim.opt.fillchars:get()
  local foldopen = fillchars.foldopen or get_icon 'FoldOpened'
  local foldclosed = fillchars.foldclose or get_icon 'FoldClosed'
  local foldsep = fillchars.foldsep or get_icon 'FoldSeparator'
  return function() -- move to M.fold_indicator
    local wp = ffi.C.find_window_by_handle(0, ffi.new 'Error') -- get window handler
    local width = ffi.C.compute_foldcolumn(wp, 0) -- get foldcolumn width
    -- get fold info of current line
    local foldinfo = width > 0 and ffi.C.fold_info(wp, vim.v.lnum) or { start = 0, level = 0, llevel = 0, lines = 0 }

    local str = ''
    if width ~= 0 then
      str = vim.v.relnum > 0 and '%#FoldColumn#' or '%#CursorLineFold#'
      if foldinfo.level == 0 then
        str = str .. (' '):rep(width)
      else
        local closed = foldinfo.lines > 0
        local first_level = foldinfo.level - width - (closed and 1 or 0) + 1
        if first_level < 1 then
          first_level = 1
        end

        for col = 1, width do
          str = str
            .. (
              (vim.v.virtnum ~= 0 and foldsep)
              or ((closed and (col == foldinfo.level or col == width)) and foldclosed)
              or ((foldinfo.start == vim.v.lnum and first_level + col > foldinfo.llevel) and foldopen)
              or foldsep
            )
          if col == foldinfo.level then
            str = str .. (' '):rep(width - col)
            break
          end
        end
      end
    end
    return status_utils.stylize(str .. '%*', opts)
  end
end

return M
